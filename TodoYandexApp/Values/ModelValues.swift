//
//  ModelValues.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 26.06.23.
//

import Foundation

class ModelValues {
    static let todosUrl = URL.documentsDirectory.appending(component: "todos.json")
    static let todoSQLiteUrlString = URL.documentsDirectory.appending(component: "todos.sqlite3").absoluteString
}
