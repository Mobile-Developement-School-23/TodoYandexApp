//
//  TodoDetailsViewModel.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 23.06.23.
//

import UIKit

class TodoDetailsViewModel {
    private let loadUrl: URL = URL.documentsDirectory.appending(component: "details.json")
    private let fileCache = FileCache<TodoItem>()
    private var todoItem: TodoItem? = nil
    private var stringColor: String? = nil
    
    private(set) var text: String = ""
    private(set) var deadline: Date? = nil
    private(set) var importance: TodoItemImportance = .basic
    private(set) var isSaved = false
    private(set) var color: UIColor?
    
    private var delegates = [() -> Void]()
    
    public var mainHandler: TodoDetailsViewModelMainHandler?
    
    func saveChanges() {
        guard let todoItem = todoItem else {
            self.todoItem = TodoItem(text: text, importance: importance, deadline: deadline, color: stringColor)
            saveItemAsJson(self.todoItem!)
            return
        }
        
        self.todoItem = TodoItem(id: todoItem.id, text: text, importance: importance, deadline: deadline, done: todoItem.done, createdAt: todoItem.createdAt, changedAt: Date.now, color: stringColor)
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
        stringColor = todoItem?.color
        
        if stringColor != nil {
            color = UIColor(hexString: stringColor!) ?? AssetsColors.labelPrimary
        }
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
    
    func onColorChanged(_ color: UIColor?) {
        if color != AssetsColors.labelPrimary {
            self.color = color
            stringColor = color?.htmlRGBColor
        } else {
            self.color = nil
            stringColor = nil
        }
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
