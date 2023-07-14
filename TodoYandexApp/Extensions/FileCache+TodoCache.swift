//
//  FileCache+TodoCache.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 13.07.23.
//

import FileCachePackage

extension FileCache<TodoItem>: TodoCache {
    var items: [TodoItem] {
        return Array(itemsById.values)
    }
    
    func saveChanges() {
        try? saveAsJsonFile(withURL: ModelValues.todosUrl)
    }
    
    func load() {
        try? loadFromJsonFile(withURL: ModelValues.todosUrl)
    }
    
    func contains(withId id: String) -> Bool {
        itemsById.keys.contains(id)
    }
}
