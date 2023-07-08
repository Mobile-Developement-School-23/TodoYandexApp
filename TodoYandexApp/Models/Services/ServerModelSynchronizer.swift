//
//  ServerModelSynchronizer.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 7.07.23.
//

import Foundation
import FileCachePackage

@MainActor
class ServerModelSynchronizer {
    private let fileCache: FileCache<TodoItem>
    private let api = DefaultApiAccessor()
    
    private var remoteItems: [TodoItem] = []
    
    private var isDurty = true
    private var isInMerging = false
    
    //Писал в чат по поводу этой волшебной штуки, она FIFO
    //Соль в том что для любой сетевой операции я блокирую этот мьютекс и разблокирую как все закончится. И за счет этого все операции идут друг за дружкой и не перезаписывают друг друга. Сказка
    //UPD блочит главный тред. Лучше уж с дата рейсами чем с дедлоками. Есть идеи как фиксить, но на часах 4 а тут баги пострашнее(
    private var mutex = pthread_mutex_t()
    
    weak var controller: TodoListViewController?
    
    init(fileCache: FileCache<TodoItem>) {
        self.fileCache = fileCache
        api.setRevisionHandler(onRevisionChanged)
        api.setRevision(getStoredRevision())
        api.errorHandler = onApiFailure
        pthread_mutex_init(&mutex, nil)
    }
    
    func loadModel() {
        remoteItems = Array(fileCache.itemsById.values)
        mergeUpdateAndReplaceWithServer()
    }
    
    func deleteItem(_ item: TodoItem) {
        remoteItems.removeAll(where: {$0.id == item.id})
        
        Task {
            lockMutex()
            requestStarted()
            await api.deleteTodoItem(with: item.id)
            requestEnded()
            unlockMutex()
        }
    }
    
    func addItem(_ item: TodoItem) {
        if !remoteItems.contains(where: {$0.id == item.id}) {
            remoteItems.append(item)
        } else {
            updateItem(item)
            return
        }
        
        Task {
            lockMutex()
            requestStarted()
            await api.addTodoItem(item)
            requestEnded()
            unlockMutex()
        }
    }
    
    func updateItem(_ item: TodoItem) {
        remoteItems.removeAll(where: {$0.id == item.id})
        remoteItems.append(item)
        
        Task {
            lockMutex()
            requestStarted()
            await api.updateTodoItem(item)
            requestEnded()
            unlockMutex()
        }
    }
    
    func mergeUpdateAndReplaceWithServer() {
        let storedRevision = getStoredRevision()
        if isInMerging {
            return
        }
        isInMerging = true
        Task {
            lockMutex()
            requestStarted()
            let newItems = await api.loadTodoItems()
            if storedRevision >= api.getRevision() {
                remoteItems = await api.updateTodoItems(with: remoteItems)
                applyRemoteItems()
            } else {
                remoteItems = newItems
                applyRemoteItems()
            }
            isDurty = false
            isInMerging = false
            requestEnded()
            unlockMutex()
        }
    }
    
    private func lockMutex() {
        //pthread_mutex_lock(&mutex)
    }
    
    private func unlockMutex() {
        //pthread_mutex_unlock(&self.mutex)
    }
    
    private func requestStarted() {
        DispatchQueue.main.async {
            self.controller?.activityIndicator.startAnimating()
        }
    }
    
    private func requestEnded() {
        DispatchQueue.main.async {
            self.controller?.activityIndicator.stopAnimating()
        }
    }
    
    private func applyRemoteItems() {
        if remoteItems.sorted(by: {$0.id > $1.id}) != fileCache.itemsById.values.sorted(by: {$0.id > $1.id}) {
            fileCache.removeRangeOfItems(withIds: Array(fileCache.itemsById.keys))
            fileCache.setRange(ofItems: remoteItems)
            try? fileCache.saveAsJsonFile(withURL: ModelValues.todosUrl)
            controller?.reloadData()
        }
    }
    
    private func getStoredRevision() -> Int32 {
        return UserDefaults.standard.object(forKey: "revision") as? Int32 ?? 0
    }
    
    private func onRevisionChanged(_ revision: Int32) {
        guard revision != getStoredRevision() else {
            return
        }
        
        UserDefaults.standard.set(revision, forKey: "revision")
    }
    
    private func onApiFailure() {
        mergeUpdateAndReplaceWithServer()
    }
}
