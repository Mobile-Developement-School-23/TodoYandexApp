//
//  DefaultApiAccessor.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 6.07.23.
//

import Foundation
import CocoaLumberjackSwift

class DefaultApiAccessor: ApiAccessor {
    private let minDelay = 2.0
    private let maxDelay = 120.0
    private let syncRequestDelay = 2.0
    private let delayFactor = 1.5
    private let delayTryesCount = 5
    
    var errorHandler: (() -> Void) = {}
    
    private(set) var revisionMutex = NSLock()
    private(set) var revision: Int32 = 0
    
    private(set) var deviceIdMutex = NSLock()
    private(set) var deviceId = ""
    
    private var revisionHandler: ((Int32) -> Void)?
    
    func loadTodoItems(_ tryNum: Int = 0) async -> [TodoItem] {
        if tryNum > 0 {
            DDLogInfo("Request retry \(tryNum)!")
        }
        
        let request = getBasicRequest(ServerValues.listUrl)
        let turple  = try? await URLSession.shared.dataTask(for: request)
        guard let data = turple?.0 as? Data, let response = turple?.1 as? HTTPURLResponse else {
            DDLogInfo("Get items request failed!")
            return await retryLoadTodoItems(tryNum)
        }
        
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            DDLogInfo("Response with unseccessful status code \(response.statusCode)!")
            if response.statusCode < 500 {
                errorHandler()
                return []
            }
            return await retryLoadTodoItems(tryNum)
        }
        
        let decoder = JSONDecoder()
        let dto = try? decoder.decode(ItemsListDto.self, from: data)
        guard let dto = dto else {
            DDLogInfo("Get items response json parsing error!")
            return await retryLoadTodoItems(tryNum)
        }
        
        if dto.status != "ok" {
            DDLogInfo("Response with unseccessful status \(dto.status)!")
        }
        
        setRevision(dto.revision)
        return dto.list.map { TodoItem(id: $0.id, text: $0.text, importance: $0.importance,
                                       deadline: $0.convertedDeadline, done: $0.done, createdAt: $0.convertedCreationDate,
                                       changedAt: $0.convertedChangingDate, color: $0.color) }
    }
    
    func updateTodoItems(with items: [TodoItem], _ tryNum: Int = 0) async -> [TodoItem] {
        if tryNum > 0 {
            DDLogInfo("Request retry \(tryNum)!")
        }
        
        let reqDto = ItemsListDto(status: "ok", list: items.map {TodoItemDto.fromTodoItem($0, withDeviceId: getDeviceId())}, revision: getRevision())
        
        var request = getBasicRequest(ServerValues.listUrl, withRevision: true)
        request.httpBody = try? JSONEncoder().encode(reqDto)
        request.httpMethod = "PATCH"
        
        let turple  = try? await URLSession.shared.dataTask(for: request)
        guard let data = turple?.0 as? Data, let response = turple?.1 as? HTTPURLResponse else {
            DDLogInfo("Patch items request failed!")
            return await retryUpdateTodoItems(items, tryNum)
        }
        
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            DDLogInfo("Response with unseccessful status code \(response.statusCode)!")
            if response.statusCode < 500 {
                errorHandler()
                return []
            }
            return await retryUpdateTodoItems(items, tryNum)
        }
        
        let decoder = JSONDecoder()
        let dto = try? decoder.decode(ItemsListDto.self, from: data)
        guard let dto = dto else {
            DDLogInfo("Patch items response json parsing error!")
            return await retryUpdateTodoItems(items, tryNum)
        }
        
        if dto.status != "ok" {
            DDLogInfo("Response with unseccessful status \(dto.status)!")
        }
        
        setRevision(dto.revision)
        
        return dto.list.map { TodoItem(id: $0.id, text: $0.text, importance: $0.importance,
                                       deadline: $0.convertedDeadline, done: $0.done, createdAt: $0.convertedCreationDate,
                                       changedAt: $0.convertedChangingDate, color: $0.color) }
    }
    
    func addTodoItem(_ item: TodoItem, _ tryNum: Int = 0) async {
        if tryNum > 0 {
            DDLogInfo("Request retry \(tryNum)!")
        }
        
        let reqDto = SingleItemDto(status: "ok", element: TodoItemDto.fromTodoItem(item, withDeviceId: getDeviceId()), revision: getRevision())
        
        var request = getBasicRequest(ServerValues.listUrl, withRevision: true)
        request.httpBody = try? JSONEncoder().encode(reqDto)
        request.httpMethod = "POST"
        
        let turple  = try? await URLSession.shared.dataTask(for: request)
        guard let data = turple?.0 as? Data, let response = turple?.1 as? HTTPURLResponse else {
            DDLogInfo("Add item request failed!")
            return await retryAddTodoItem(item, tryNum)
        }
        
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            DDLogInfo("Response with unseccessful status code \(response.statusCode)!")
            if response.statusCode < 500 {
                errorHandler()
                return
            }
            return await retryAddTodoItem(item, tryNum)
        }
        
        let decoder = JSONDecoder()
        let dto = try? decoder.decode(SingleItemDto.self, from: data)
        guard let dto = dto else {
            DDLogInfo("Add item response json parsing error!")
            return await retryAddTodoItem(item, tryNum)
        }
        
        if dto.status != "ok" {
            DDLogInfo("Response with unseccessful status \(dto.status)!")
        }
        
        setRevision(dto.revision)
    }
    
    func deleteTodoItem(with id: String, _ tryNum: Int = 0) async {
        if tryNum > 0 {
            DDLogInfo("Request retry \(tryNum)!")
        }
        
        var request = getBasicRequest(ServerValues.listUrl.appending(component: id), withRevision: true)
        request.httpMethod = "DELETE"
        
        let turple = try? await URLSession.shared.dataTask(for: request)
        guard let data = turple?.0 as? Data, let response = turple?.1 as? HTTPURLResponse else {
            DDLogInfo("Delete item request failed!")
            return await retryDeleteTodoItem(id, tryNum)
        }
        
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            DDLogInfo("Response with unseccessful status code \(response.statusCode)!")
            if response.statusCode < 500 {
                errorHandler()
                return
            }
            return await retryDeleteTodoItem(id, tryNum)
        }
        
        let decoder = JSONDecoder()
        let dto = try? decoder.decode(SingleItemDto.self, from: data)
        guard let dto = dto else {
            DDLogInfo("Delete item response json parsing error!")
            return await retryDeleteTodoItem(id, tryNum)
        }
        
        if dto.status != "ok" {
            DDLogInfo("Response with unseccessful status \(dto.status)!")
        }
        
        setRevision(dto.revision)
    }
    
    func getTodoItem(by id: String, _ tryNum: Int = 0) async -> TodoItem? {
        if tryNum > 0 {
            DDLogInfo("Request retry \(tryNum)!")
        }
        
        var request = getBasicRequest(ServerValues.listUrl.appending(component: id), withRevision: true)
        request.httpMethod = "GET"
        
        let turple  = try? await URLSession.shared.dataTask(for: request)
        guard let data = turple?.0 as? Data, let response = turple?.1 as? HTTPURLResponse else {
            DDLogInfo("Get item request failed!")
            return await retryGetTodoItem(id, tryNum)
        }
        
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            DDLogInfo("Response with unseccessful status code \(response.statusCode)!")
            if response.statusCode < 500 {
                errorHandler()
                return nil
            }
            return await retryGetTodoItem(id, tryNum)
        }
        
        let decoder = JSONDecoder()
        let dto = try? decoder.decode(SingleItemDto.self, from: data)
        guard let dto = dto else {
            DDLogInfo("Get item response json parsing error!")
            return await retryGetTodoItem(id, tryNum)
        }
        
        if dto.status != "ok" {
            DDLogInfo("Response with unseccessful status \(dto.status)!")
        }
        
        setRevision(dto.revision)
        
        return TodoItem(id: dto.element.id, text: dto.element.text, importance: dto.element.importance, deadline: dto.element.convertedDeadline, done: dto.element.done, createdAt: dto.element.convertedCreationDate, changedAt: dto.element.convertedChangingDate, color: dto.element.color)
    }
    
    func updateTodoItem(_ item: TodoItem, _ tryNum: Int = 0) async {
        if tryNum > 0 {
            DDLogInfo("Request retry \(tryNum)!")
        }
        
        let reqDto = SingleItemDto(status: "ok", element: TodoItemDto.fromTodoItem(item, withDeviceId: getDeviceId()), revision: getRevision())
        
        var request = getBasicRequest(ServerValues.listUrl.appending(component: item.id), withRevision: true)
        request.httpBody = try? JSONEncoder().encode(reqDto)
        request.httpMethod = "PUT"
        
        let turple  = try? await URLSession.shared.dataTask(for: request)
        guard let data = turple?.0 as? Data, let response = turple?.1 as? HTTPURLResponse else {
            DDLogInfo("Update item request failed!")
            return await updateTodoItem(item, tryNum + 1)
        }
        
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            DDLogInfo("Response with unseccessful status code \(response.statusCode)!")
            if response.statusCode < 500 {
                errorHandler()
                return
            }
            return await updateTodoItem(item, tryNum + 1)
        }
        
        let decoder = JSONDecoder()
        let dto = try? decoder.decode(SingleItemDto.self, from: data)
        guard let dto = dto else {
            DDLogInfo("Update item response json parsing error!")
            return await updateTodoItem(item, tryNum + 1)
        }
        
        if dto.status != "ok" {
            DDLogInfo("Response with unseccessful status \(dto.status)!")
        }
        
        setRevision(dto.revision)
    }
    
    func setRevision(_ revision: Int32) {
        revisionMutex.lock()
        self.revision = revision
        
        if let revisionHandler = revisionHandler {
            revisionHandler(revision)
        }
        
        revisionMutex.unlock()
    }
    
    func getRevision() -> Int32 {
        revisionMutex.lock()
        let copy = revision
        revisionMutex.unlock()
        return copy
    }
    
    func setDeviceId(_ deviceId: String) {
        deviceIdMutex.lock()
        self.deviceId = deviceId
        deviceIdMutex.unlock()
    }
    
    func getDeviceId() -> String {
        deviceIdMutex.lock()
        let copy = deviceId
        deviceIdMutex.unlock()
        return copy
    }
    
    func setRevisionHandler(_ handler: ((Int32) -> Void)?) {
        self.revisionHandler = handler
    }
    
    private func getBasicRequest(_ url: URL, withRevision: Bool = false) -> URLRequest {
        var req = URLRequest(url: url)
        req.addValue(ServerValues.authorizationHeaderValue, forHTTPHeaderField: "Authorization")
        //req.addValue("50", forHTTPHeaderField: "X-Generate-Fails")
        if withRevision {
            req.addValue(String(getRevision()), forHTTPHeaderField: "X-Last-Known-Revision")
        }
        return req;
    }
    
    private func getDelay(_ tryNum: Int) -> Int {
        return Int(min(maxDelay, Double(tryNum) * delayFactor * minDelay))
    }
    
    private func retryLoadTodoItems(_ tryNum: Int) async -> [TodoItem] {
        try? await Task.sleep(for: .seconds(syncRequestDelay))
        return await loadTodoItems(tryNum + 1)
    }
    
    private func retryUpdateTodoItems(_ with: [TodoItem], _ tryNum: Int) async -> [TodoItem] {
        try? await Task.sleep(for: .seconds(syncRequestDelay))
        return await updateTodoItems(with: with, tryNum + 1)
    }
    
    private func retryAddTodoItem(_ item: TodoItem, _ tryNum: Int = 0) async {
        if tryNum < delayTryesCount {
            try? await Task.sleep(for: .seconds(getDelay(tryNum)))
            await addTodoItem(item, tryNum + 1)
        } else {
            errorHandler()
            return
        }
    }
    
    private func retryDeleteTodoItem(_ id: String, _ tryNum: Int = 0) async {
        if tryNum < delayTryesCount {
            try? await Task.sleep(for: .seconds(getDelay(tryNum)))
            await deleteTodoItem(with: id, tryNum + 1)
        } else {
            errorHandler()
            return
        }
    }
    
    private func retryUpdateTodoItem(_ item: TodoItem, _ tryNum: Int = 0) async {
        if tryNum < delayTryesCount {
            try? await Task.sleep(for: .seconds(getDelay(tryNum)))
            await updateTodoItem(item, tryNum + 1)
        } else {
            errorHandler()
            return
        }
    }
    
    private func retryGetTodoItem(_ id: String, _ tryNum: Int = 0) async -> TodoItem? {
        if tryNum < delayTryesCount {
            try? await Task.sleep(for: .seconds(getDelay(tryNum)))
            return await getTodoItem(by: id, tryNum + 1)
        } else {
            errorHandler()
            return nil
        }
    }
}
