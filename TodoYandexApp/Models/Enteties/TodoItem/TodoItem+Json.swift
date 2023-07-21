//
//  TodoItem+Json.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 12.06.23.
//

import Foundation

extension TodoItem: JsonCompatible {
    /// Returns json dictionary [String: Any]
    var json: Any {
        var jsonDictionary: [String: Any] = [:]
        jsonDictionary[CodingKeys.id.stringValue] = id
        jsonDictionary[CodingKeys.text.stringValue] = text
        jsonDictionary[CodingKeys.createdAt.stringValue] = createdAt.timeIntervalSince1970
        jsonDictionary[CodingKeys.done.stringValue] = done
        if importance != .basic {
            jsonDictionary[CodingKeys.importance.stringValue] = importance.rawValue
        }
        if deadline != nil {
            jsonDictionary[CodingKeys.deadline.stringValue] = deadline!.timeIntervalSince1970
        }
        if changedAt != nil {
            jsonDictionary[CodingKeys.changedAt.stringValue] = changedAt!.timeIntervalSince1970
        }
        jsonDictionary[CodingKeys.color.stringValue] = color

        return jsonDictionary
    }

    /// Can parse json when it is one of the following types: String, Data or [String: Any]
    static func parse(json: Any) -> TodoItem? {
        if let jsonString = json as? String {
            return parse(fromString: jsonString)

        } else if let jsonData = json as? Data {
            return parse(fromData: jsonData)

        } else if let jsonDictionary = json as? [String: Any] {
            return parse(fromDictionary: jsonDictionary)

        } else {
            return nil
        }
    }

    static func parse(fromString jsonString: String) -> TodoItem? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }

        return parse(fromData: jsonData)
    }

    static func parse(fromData jsonData: Data) -> TodoItem? {
        let dict = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        guard dict != nil else {
            return nil
        }

        return parse(fromDictionary: dict!)
    }

    static func parse(fromDictionary dict: [String: Any]) -> TodoItem? {
        let id = dict[CodingKeys.id.stringValue] as? String ?? UUID().uuidString
        let text = dict[CodingKeys.text.stringValue] as? String
        let done = dict[CodingKeys.done.stringValue] as? Bool ?? false
        let color = dict[CodingKeys.color.stringValue] as? String
        let importance: TodoItemImportance
        if let importanceString = dict[CodingKeys.importance.stringValue] as? String {
            importance = TodoItemImportance(rawValue: importanceString) ?? .basic
        } else {
            importance = .basic
        }
        var deadline: Date?
        var createdAt: Date?
        var changedAt: Date?

        var timeInterval = dict[CodingKeys.deadline.stringValue] as? TimeInterval
        if timeInterval != nil {
            deadline = Date(timeIntervalSince1970: timeInterval!)
        }

        timeInterval = dict[CodingKeys.createdAt.stringValue] as? TimeInterval
        if timeInterval != nil {
            createdAt = Date(timeIntervalSince1970: timeInterval!)
        }

        timeInterval = dict[CodingKeys.changedAt.stringValue] as? TimeInterval
        if timeInterval != nil {
            changedAt = Date(timeIntervalSince1970: timeInterval!)
        }

        if text == nil || createdAt == nil {
            return nil
        }

        return TodoItem(id: id, text: text!, importance: importance, deadline: deadline,
                        done: done, createdAt: createdAt!, changedAt: changedAt, color: color)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case done
        case importance
        case deadline
        case createdAt
        case changedAt
        case color
    }
}
