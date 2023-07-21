//
//  TodoData+CoreDataConversion.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 13.07.23.
//

//import Foundation
//
//extension TodoItem {
//    static func fromCoreDataTodoItem(_ item: CoreDataTodoItem) -> TodoItem? {
//        guard let id = item.id,
//              let text = item.text,
//              let importanceText = item.importance,
//              let importance = TodoItemImportance(rawValue: importanceText),
//              let createdAt = item.createdAt else {
//            return nil
//        }
//
//        return TodoItem(id: id, text: text, importance: importance,
//                        deadline: item.deadline, done: item.done, createdAt: createdAt,
//                        changedAt: item.changedAt, color: item.color)
//    }
//
//    func applyDataToCoreTodoItem(_ item: CoreDataTodoItem) {
//        item.id = id
//        item.changedAt = changedAt
//        item.color = color
//        item.createdAt = createdAt
//        item.deadline = deadline
//        item.done = done
//        item.importance = importance.rawValue
//        item.text = text
//    }
//}
