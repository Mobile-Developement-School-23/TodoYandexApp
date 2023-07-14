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
    private let cache: TodoCache
    private let api = DefaultApiAccessor()
    
    private var remoteItems: [TodoItem] = []
    
    private var isInMerging = false
    
    //Писал в чат по поводу этой волшебной штуки, она FIFO
    //Соль в том что для любой сетевой операции я блокирую этот мьютекс и разблокирую как все закончится. И за счет этого все операции идут друг за дружкой и не перезаписывают друг друга. Сказка
    //UPD блочит главный тред. Лучше уж с дата рейсами чем с дедлоками. Есть идеи как фиксить, но на часах 4 а тут баги пострашнее(
    private var mutex = pthread_mutex_t()
    
    weak var controller: TodoListViewController?
    
    init(cache: TodoCache) {
        self.cache = cache
        api.setRevisionHandler(onRevisionChanged)
        api.setRevision(getStoredRevision())
        api.errorHandler = onApiFailure
        pthread_mutex_init(&mutex, nil)
    }
    
    func loadModel() {
        remoteItems = cache.items
        mergeUpdateAndReplaceWithServer()
    }
    
    func deleteItem(_ item: TodoItem) {
        remoteItems = cache.items
        
        Task {
            lockMutex()
            requestStarted()
            await api.deleteTodoItem(with: item.id)
            requestEnded()
            unlockMutex()
        }
    }
    
    func addItem(_ item: TodoItem) {
        remoteItems = cache.items
        
        Task {
            lockMutex()
            requestStarted()
            await api.addTodoItem(item)
            requestEnded()
            unlockMutex()
        }
    }
    
    func updateItem(_ item: TodoItem) {
        remoteItems = cache.items
        
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
            setIsDurty(false)
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
        if remoteItems.sorted(by: {$0.id > $1.id}) != cache.items.sorted(by: {$0.id > $1.id}) {
            cache.removeRange(ofItems: cache.items)
            cache.setRange(ofItems: remoteItems)
            cache.saveChanges()
            controller?.reloadData()
        }
    }
    
    private func getStoredRevision() -> Int32 {
        return UserDefaults.standard.object(forKey: "revision") as? Int32 ?? 0
    }
    
    private func getIsDirty() -> Bool {
        return UserDefaults.standard.object(forKey: "dirty") as? Bool ?? false
    }
    
    private func setIsDurty(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "dirty")
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
