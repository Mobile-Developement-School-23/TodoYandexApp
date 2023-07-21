//
//  TodoItem+CSV.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 15.06.23.
//

import Foundation

extension TodoItem: CsvCompatible {
    var csv: String {
        return "\"\(id)\";\"\(text)\";\"\(done ? "true" : "false")"
        + "\";\"\(importance != .basic ? importance.rawValue : "")"
        + "\";\"\(deadline != nil ? String(deadline!.timeIntervalSince1970) : "")"
        + "\";\"\(String(createdAt.timeIntervalSince1970))\""
        + ";\"\(changedAt != nil ? String(changedAt!.timeIntervalSince1970) : "")\""
    }

    /// Parse csv file, delimeter must be ";", the values must go in the order given by init,
    /// qutes (") in values must be replaced with (""")
    /// WARN: NOT WORKING WHEN CSV VALUES CONTAINS QUOTES("), fix coming soon...
    static func parse(csv: String) -> TodoItem? {
        var data = [String?]()
        var inQuote = false
        var currentString = ""

        for character in csv {
            switch character {
            case "\"":
                inQuote = !inQuote
                continue

            case ";":
                if !inQuote {
                    data.append(currentString.isEmpty ? nil : currentString)
                    currentString = ""
                    continue
                }

            default:
                break
            }

            currentString.append(character)
        }
        data.append(currentString.isEmpty ? nil : currentString)

        return parse(fromCsvArray: data)
    }

    static func parse(fromCsvArray arr: [String?]) -> TodoItem? {
        if arr.count != 7 {
            return nil
        }

        let id = arr[0] ?? UUID().uuidString
        let text = arr[1]
        let done = arr[2] != nil ? arr[2] == "true" : false
        let importance: TodoItemImportance = TodoItemImportance(rawValue: arr[3] ?? "0") ?? .basic
        var deadline: Date?
        var createdAt: Date?
        var changedAt: Date?

        if arr[4] != nil {
            let doubleInterval = Double(arr[4]!)
            if doubleInterval != nil {
                let timeInterval = TimeInterval(doubleInterval!)
                deadline = Date(timeIntervalSince1970: timeInterval)
            }
        }

        if arr[5] != nil {
            let doubleInterval = Double(arr[5]!)
            if doubleInterval != nil {
                let timeInterval = TimeInterval(doubleInterval!)
                createdAt = Date(timeIntervalSince1970: timeInterval)
            }
        }

        if arr[6] != nil {
            let doubleInterval = Double(arr[6]!)
            if doubleInterval != nil {
                let timeInterval = TimeInterval(doubleInterval!)
                changedAt = Date(timeIntervalSince1970: timeInterval)
            }
        }

        if text == nil || createdAt == nil {
            return nil
        }

        return TodoItem(id: id, text: text!, importance: importance, deadline: deadline,
                        done: done, createdAt: createdAt!, changedAt: changedAt)
    }
}
