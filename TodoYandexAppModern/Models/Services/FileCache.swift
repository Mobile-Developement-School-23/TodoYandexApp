//
//  FileCache.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 12.06.23.
//

import Foundation

public protocol JsonCompatible {
    var json: Any { get }
    static func parse(json: Any) -> Self?
}

public protocol CsvCompatible {
    var csv: String { get }
    static func parse(csv: String) -> Self?
}

public class FileCache<ItemType: Identifiable & JsonCompatible & CsvCompatible> {
    private var mutex = NSRecursiveLock()
    
    public private(set) var itemsById: [ItemType.ID: ItemType] = Dictionary()

    public init() {}

    public init(withItems items: some Collection<ItemType>) {
        mutex.lock()
        setRange(ofItems: items)
        mutex.unlock()
    }

    /// Adds or replaces item in cache by its item.id
    public func set(item: ItemType) {
        mutex.lock()
        itemsById[item.id] = item
        mutex.unlock()
    }

    /// Calling set(item: ItemType) for each element in items
    public func setRange(ofItems items: some Collection<ItemType>) {
        mutex.lock()
        items.forEach({self.set(item: $0)})
        mutex.unlock()
    }

    /// Removes item in cache by its item.id
    public func remove(item: ItemType) {
        mutex.lock()
        itemsById.removeValue(forKey: item.id)
        mutex.unlock()
    }

    /// Removes item in cache with id == item.id
    public func removeItem(withId id: ItemType.ID) {
        mutex.lock()
        itemsById.removeValue(forKey: id)
        mutex.unlock()
    }

    /// Calling remove(item: ItemType) for each element in items
    public func removeRange(ofItems items: some Collection<ItemType>) {
        mutex.lock()
        items.forEach({self.remove(item: $0)})
        mutex.unlock()
    }

    /// Calling removeItem(withId id: ItemType.ID) for each element in ids
    public func removeRangeOfItems(withIds ids: some Collection<ItemType.ID>) {
        mutex.lock()
        ids.forEach({self.removeItem(withId: $0)})
        mutex.unlock()
    }
}

extension FileCache {
    public enum FileCacheError: Error {
        case serializationError
        case deserializationError
    }

    public func saveAsJsonFile(withURL url: URL) throws {
        mutex.lock()
        let json = self.itemsById.values.map({$0.json})

        if !JSONSerialization.isValidJSONObject(json) {
            mutex.unlock()
            throw FileCacheError.serializationError
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            mutex.unlock()
            throw FileCacheError.serializationError
        }

        do {
            try jsonData.write(to: url)
        } catch {
            mutex.unlock()
            throw error
        }
        
        mutex.unlock()
    }

    public func loadFromJsonFile(withURL url: URL) throws {
        mutex.lock()
        var jsonData: Data
        do {
            jsonData = try Data(contentsOf: url)
        } catch {
            mutex.unlock()
            throw error
        }

        guard let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            mutex.unlock()
            throw FileCacheError.deserializationError
        }

        let items = jsonArray.compactMap { ItemType.parse(json: $0) }
        mutex.unlock()
        removeRangeOfItems(withIds: itemsById.keys)
        setRange(ofItems: items)
    }

    public func saveAsCsvFile(withURL url: URL) throws {
        mutex.lock()
        guard let csvData = self.itemsById.values.map({$0.csv}).joined(separator: "\n").data(using: .utf8) else {
            mutex.unlock()
            throw FileCacheError.serializationError
        }
        mutex.unlock()

        do {
            try csvData.write(to: url)
        } catch {
            throw error
        }
    }

    public func loadFromCsvFile(withURL url: URL) throws {
        var csvData: Data
        do {
            csvData = try Data(contentsOf: url)
        } catch {
            throw error
        }

        guard let csv = String(data: csvData, encoding: .utf8) else {
            throw FileCacheError.deserializationError
        }

        let csvItemArray = csv.split(separator: "\n")

        let items = csvItemArray.compactMap { ItemType.parse(csv: String($0)) }
        mutex.lock()
        removeRangeOfItems(withIds: itemsById.keys)
        setRange(ofItems: items)
        mutex.unlock()
    }
}
