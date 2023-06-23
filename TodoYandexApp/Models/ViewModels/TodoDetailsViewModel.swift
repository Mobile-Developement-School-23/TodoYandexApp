//
//  TodoDetailsViewModel.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 23.06.23.
//

import Foundation

class TodoDetailsViewModel {
    private let loadUrl: URL = URL.documentsDirectory.appending(component: "details.json")
    private let fileCache = FileCache<TodoItem>()
    private var todoItem: TodoItem? = nil
    
    private(set) var text: String = ""
    private(set) var deadline: Date? = nil
    private(set) var importance: TodoItemImportance = .basic
    private(set) var isSaved = false
    
    private var delegates = [() -> Void]()
    
    public var mainHandler: TodoDetailsViewModelMainHandler?
    
    func saveChanges() {
        guard let todoItem = todoItem else {
            self.todoItem = TodoItem(text: text, importance: importance, deadline: deadline)
            saveItemAsJson(self.todoItem!)
            return
        }
        
        self.todoItem = TodoItem(id: todoItem.id, text: text, importance: importance, deadline: deadline, done: todoItem.done, createdAt: todoItem.createdAt, changedAt: Date.now)
        saveItemAsJson(self.todoItem!)
    }
    
    private func saveItemAsJson(_ item: TodoItem) {
        fileCache.set(item: item)
        do {
            try fileCache.saveAsJsonFile(withURL: loadUrl)
        } catch {
            mainHandler?.onFileSaveError()
        }
    }
    
    func loadTodoItem() {
        try? fileCache.loadFromJsonFile(withURL: loadUrl)
        todoItem = fileCache.itemsById.values.first
        isSaved = todoItem != nil
        text = todoItem?.text ?? ""
        deadline = todoItem?.deadline
        importance = todoItem?.importance ?? .basic
        notifyDelegates()
    }
    
    func deleteTodoItem() {
        guard todoItem != nil else {
            return
        }
        
        fileCache.remove(item: todoItem!)
        do {
            try fileCache.saveAsJsonFile(withURL: loadUrl)
            mainHandler?.onTodoItemDeleted()
        } catch {
            mainHandler?.onFileSaveError()
        }
    }
    
    func onTextChanged(_ text: String) {
        self.text = text
        notifyDelegates()
    }
    
    func onDateChanged(_ date: Date?) {
        self.deadline = date
        notifyDelegates()
    }
    
    func onImportanceChanged(_ importance: TodoItemImportance) {
        self.importance = importance
        notifyDelegates()
    }
    
    func onColorChanged() {
        notifyDelegates()
    }
    
    func notifyDelegates() {
        for delegate in delegates {
            delegate()
        }
    }
    
    func addDelegate(_ delegate: @escaping () -> Void) {
        delegates.append(delegate)
    }
}

protocol TodoDetailsViewModelMainHandler {
    func onFileSaveError()
    
    func onTodoItemDeleted()
}
