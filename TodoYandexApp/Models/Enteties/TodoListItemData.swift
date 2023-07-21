//
//  ListTodoItem.swift
//  TodoYandexAppModern
//
//  Created by Илья Колесников on 19.07.23.
//

import Foundation

struct TodoListItemData: Identifiable {
    let id: String
    let text: String
    let importance: TodoItemImportance
    let done: Bool
    let color: String?
    let deadline: Date?
    
    init(id: String, text: String, importance: TodoItemImportance, done: Bool, color: String? = nil, deadline: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.done = done
        self.color = color
        self.deadline = deadline
    }
}
