//
//  TodoItemDto.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 6.07.23.
//

import UIKit

struct TodoItemDto: Codable {
    let id: String
    let text: String
    let importance: TodoItemImportance
    let deadline: Int64?
    let done: Bool
    let color: String?
    let created_at: Int64
    let changed_at: Int64
    let last_updated_by: String
    
    var convertedDeadline: Date? {
        guard let deadline = deadline else {
            return nil
        }
        
        return Date(timeIntervalSince1970: Double(deadline))
    }
    
    var convertedCreationDate: Date {
        return Date(timeIntervalSince1970: Double(created_at))
    }
    
    var convertedChangingDate: Date? {
        return Date(timeIntervalSince1970: Double(changed_at))
    }
    
    static func fromTodoItem(_ item: TodoItem, withDeviceId deviceId: String) -> TodoItemDto {
        var deadline: Int64? = nil
        var changedAt: Int64 = Int64(item.createdAt.timeIntervalSince1970)
        
        if let deadlineDate = item.deadline {
            deadline = Int64(deadlineDate.timeIntervalSince1970)
        }
        
        if let changedDate = item.changedAt {
            changedAt = Int64(changedDate.timeIntervalSince1970)
        }
        
        return TodoItemDto(id: item.id, text: item.text, importance: item.importance, deadline: deadline, done: item.done, color: item.color, created_at: Int64(item.createdAt.timeIntervalSince1970), changed_at: changedAt, last_updated_by: deviceId)
    }
}
