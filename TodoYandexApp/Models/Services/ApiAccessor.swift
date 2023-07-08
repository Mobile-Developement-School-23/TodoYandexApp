//
//  ApiAccessor.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 6.07.23.
//

import Foundation

protocol ApiAccessor {
    var errorHandler: (() -> Void) { get set }
    
    func loadTodoItems(_ tryNum: Int) async -> [TodoItem]
    func updateTodoItems(with items: [TodoItem], _ tryNum: Int) async -> [TodoItem]
    func addTodoItem(_ item: TodoItem, _ tryNum: Int) async
    func deleteTodoItem(with id: String, _ tryNum: Int) async
    func getTodoItem(by id: String, _ tryNum: Int) async -> TodoItem?
    func updateTodoItem(_ item: TodoItem, _ tryNum: Int) async
    func setRevisionHandler(_ handler: ((Int32) -> Void)?)
    func setRevision(_ revision: Int32)
    func getRevision() -> Int32
}
