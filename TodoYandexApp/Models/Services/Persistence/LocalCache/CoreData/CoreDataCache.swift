//
//  CoreDataCache.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 13.07.23.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

class CoreDataCache: TodoCache {
    var items: [TodoItem] {
        get {
            let coreItems = (try? context.fetch(CoreDataTodoItem.fetchRequest())) ?? []
            return coreItems.compactMap {
                TodoItem.fromCoreDataTodoItem($0)
            }
        }
    }
    
    var persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        context = persistentContainer.viewContext
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
        delete(withId: id)
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
    
    func saveChanges() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func load() -> [TodoItem] {
        items
    }
    
    func insert(item: TodoItem) {
        let coreItem = CoreDataTodoItem(context: context)
        item.applyDataToCoreTodoItem(coreItem)
    }
    
    func update(item: TodoItem) {
        let fetchRequest = CoreDataTodoItem.fetchRequest()
        let predicate = NSPredicate(format: "id = '\(item.id)'")
        fetchRequest.predicate = predicate
        do
        {
            let objects = try context.fetch(fetchRequest)
            var counter = objects.count
            for obj in objects {
                if counter > 1 {
                    context.delete(obj)
                } else {
                    item.applyDataToCoreTodoItem(obj)
                }
                counter-=1;
            }
        }
        catch
        {
            DDLogDebug("Error while CoreData update item with id=\(item.id)")
        }
    }
    
    func delete(withId id: String) {
        let fetchRequest = CoreDataTodoItem.fetchRequest()
        let predicate = NSPredicate(format: "id = '\(id)'")
        fetchRequest.predicate = predicate
        do
        {
            let objects = try context.fetch(fetchRequest)
            for obj in objects {
                context.delete(obj)
            }
        }
        catch
        {
            DDLogDebug("Error while CoreData delete item with id=\(id)")
        }
    }
    
    func contains(withId id: String) -> Bool {
        let fetchRequest = CoreDataTodoItem.fetchRequest()
        let predicate = NSPredicate(format: "id = '\(id)'")
        fetchRequest.predicate = predicate
        do
        {
            let objects = try context.fetch(fetchRequest)
            return objects.count >= 1
        }
        catch
        {
            DDLogDebug("Error while CoreData contains item with id=\(id)")
            return false
        }
    }
    
    func load() {
        
    }
}
