//
//  TodoItem.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 12.06.23.
//

import Foundation

struct TodoItem: Identifiable, Equatable {
    let id: String
    let text: String
    let importance: TodoItemImportance
    let deadline: Date?
    let done: Bool
    let createdAt: Date
    let changedAt: Date?
    let color: String?
    
    init(id: String = UUID().uuidString, text: String, importance: TodoItemImportance = .basic, deadline: Date? = nil, done: Bool = false, createdAt: Date = Date.now, changedAt: Date? = nil, color: String? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.done = done
        self.createdAt = createdAt
        self.changedAt = changedAt
        self.color = color
    }
    
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.importance == rhs.importance &&
        lhs.deadline?.timeIntervalSince1970 == rhs.deadline?.timeIntervalSince1970 &&
        lhs.done == rhs.done &&
        lhs.createdAt.timeIntervalSince1970 == rhs.createdAt.timeIntervalSince1970 &&
        lhs.changedAt?.timeIntervalSince1970 == rhs.changedAt?.timeIntervalSince1970
        
    }
}
