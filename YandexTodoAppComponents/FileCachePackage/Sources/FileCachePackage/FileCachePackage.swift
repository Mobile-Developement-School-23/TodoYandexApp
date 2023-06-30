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

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public class FileCache<ItemType: Identifiable & JsonCompatible & CsvCompatible> {
    public private(set) var itemsById: [ItemType.ID: ItemType] = Dictionary()

    public init() {}

    public init(withItems items: some Collection<ItemType>) {
        setRange(ofItems: items)
    }

    /// Adds or replaces item in cache by its item.id
    public func set(item: ItemType) {
        itemsById[item.id] = item
    }

    /// Calling set(item: ItemType) for each element in items
    public func setRange(ofItems items: some Collection<ItemType>) {
        items.forEach({self.set(item: $0)})
    }

    /// Removes item in cache by its item.id
    public func remove(item: ItemType) {
        itemsById.removeValue(forKey: item.id)
    }

    /// Removes item in cache with id == item.id
    public func removeItem(withId id: ItemType.ID) {
        itemsById.removeValue(forKey: id)
    }

    /// Calling remove(item: ItemType) for each element in items
    public func removeRange(ofItems items: some Collection<ItemType>) {
        items.forEach({self.remove(item: $0)})
    }

    /// Calling removeItem(withId id: ItemType.ID) for each element in ids
    public func removeRangeOfItems(withIds ids: some Collection<ItemType.ID>) {
        ids.forEach({self.removeItem(withId: $0)})
    }
}

extension FileCache {
    public enum FileCacheError: Error {
        case serializationError
        case deserializationError
    }

    public func saveAsJsonFile(withURL url: URL) throws {
        let json = self.itemsById.values.map({$0.json})

        if !JSONSerialization.isValidJSONObject(json) {
            throw FileCacheError.serializationError
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            throw FileCacheError.serializationError
        }

        do {
            try jsonData.write(to: url)
        } catch {
            throw error
        }
    }

    public func loadFromJsonFile(withURL url: URL) throws {
        var jsonData: Data
        do {
            jsonData = try Data(contentsOf: url)
        } catch {
            throw error
        }

        guard let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            throw FileCacheError.deserializationError
        }

        let items = jsonArray.compactMap { ItemType.parse(json: $0) }
        removeRangeOfItems(withIds: itemsById.keys)
        setRange(ofItems: items)
    }

    public func saveAsCsvFile(withURL url: URL) throws {
        guard let csvData = self.itemsById.values.map({$0.csv}).joined(separator: "\n").data(using: .utf8) else {
            throw FileCacheError.serializationError
        }

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
        removeRangeOfItems(withIds: itemsById.keys)
        setRange(ofItems: items)
    }
}
