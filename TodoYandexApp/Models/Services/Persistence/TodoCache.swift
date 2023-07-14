//
//  TodoCache.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 13.07.23.
//

import Foundation

protocol TodoCache {
    var items: [TodoItem] { get }
    
    func set(item: TodoItem)
    func setRange(ofItems items: some Collection<TodoItem>)
    
    func remove(item: TodoItem)
    func removeItem(withId id: TodoItem.ID)
    func removeRange(ofItems items: some Collection<TodoItem>)
    func removeRangeOfItems(withIds ids: some Collection<TodoItem.ID>)
    
    func contains(withId id: String) -> Bool
    
    func load()
    func saveChanges()
}
