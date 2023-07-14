//
//  SQLiteCache.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 15.07.23.
//

import Foundation
import SQLite

class SQLiteCache: TodoCache {
    private let db: Connection
    
    let todosTable = Table("todos")
    
    private let id = Expression<String>("id")
    private let text = Expression<String>("text")
    private let importance = Expression<String>("importance")
    private let deadline = Expression<Date?>("deadline")
    private let done = Expression<Bool>("done")
    private let createdAt = Expression<Date>("createdAt")
    private let changedAt = Expression<Date?>("changedAt")
    private let color = Expression<String?>("color")
    
    var items: [TodoItem] {
        get {
            return (try? db.prepare(todosTable).map {
                TodoItem(id: $0[id], text: $0[text], importance: TodoItemImportance(rawValue: $0[importance]) ?? .basic,
                         deadline: $0[deadline], done: $0[done], createdAt: $0[createdAt],
                         changedAt: $0[changedAt], color: $0[color])
            }) ?? []
        }
    }
    
    init() {
        do {
            db = try Connection(ModelValues.todoSQLiteUrlString)
        } catch {
            fatalError("Conntection to SQLite database is not established. There is no way to continue program -> terminating:)")
        }
        
        createTableIfNotExist()
    }
    
    func set(item: TodoItem) {
        if contains(withId: item.id) {
            update(item: item)
        } else {
            insert(item: item)
        }
    }
    
    func setRange(ofItems items: some Collection<TodoItem>) {
        for item in items {
            set(item: item)
        }
    }
    
    func remove(item: TodoItem) {
        removeItem(withId: item.id)
    }
    
    func removeItem(withId id: TodoItem.ID) {
        delete(itemWithId: id)
    }
    
    func removeRange(ofItems items: some Collection<TodoItem>) {
        for item in items {
            remove(item: item)
        }
    }
    
    func removeRangeOfItems(withIds ids: some Collection<TodoItem.ID>) {
        for id in ids {
            removeItem(withId: id)
        }
    }
    
    func insert(item: TodoItem) {
        _ = try? db.run(todosTable.insert(
            id <- item.id,
            text <- item.text,
            importance <- item.importance.rawValue,
            deadline <- item.deadline,
            done <- item.done,
            createdAt <- item.createdAt,
            changedAt <- item.changedAt,
            color <- item.color
        ))
    }
    
    func update(item: TodoItem) {
        _ = try? db.run(todosTable.filter(id == item.id).update(
            id <- item.id,
            text <- item.text,
            importance <- item.importance.rawValue,
            deadline <- item.deadline,
            done <- item.done,
            createdAt <- item.createdAt,
            changedAt <- item.changedAt,
            color <- item.color
        ))
    }
    
    func delete(itemWithId idToDelete: String) {
        _ = try? db.run(todosTable.filter(id == idToDelete).delete())
    }
    
    func contains(withId idToSearch: String) -> Bool {
        ((try? db.scalar(todosTable.filter(id == idToSearch).count)) ?? 0) > 0
    }
    
    func load() {
        
    }
    
    func saveChanges() {
        
    }
    
    private func createTableIfNotExist() {
        do {
            try db.run(todosTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(text)
                t.column(importance)
                t.column(deadline)
                t.column(done)
                t.column(createdAt)
                t.column(changedAt)
                t.column(color)
            })
        } catch {
            fatalError("Table creation failed. There is no way to continue the program:D")
        }
    }
}
