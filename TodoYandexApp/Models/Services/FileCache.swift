//
//  FileCache.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 12.06.23.
//

import Foundation

class FileCache<ItemType: Identifiable & JsonCompatible & CsvCompatible> {
    private(set) var itemsById: Dictionary<ItemType.ID, ItemType> = Dictionary()
    
    init() {}
    
    init(withItems items: some Collection<ItemType>) {
        setRange(ofItems: items)
    }
    
    ///Adds or replaces item in cache by its item.id
    func set(item: ItemType) {
        itemsById[item.id] = item
    }
    
    ///Calling set(item: ItemType) for each element in items
    func setRange(ofItems items: some Collection<ItemType>) {
        items.forEach({self.set(item: $0)})
    }
    
    ///Removes item in cache by its item.id
    func remove(item: ItemType) {
        itemsById.removeValue(forKey: item.id)
    }
    
    ///Removes item in cache with id == item.id
    func removeItem(withId id: ItemType.ID) {
        itemsById.removeValue(forKey: id)
    }
    
    ///Calling remove(item: ItemType) for each element in items
    func removeRange(ofItems items: some Collection<ItemType>) {
        items.forEach({self.remove(item: $0)})
    }
    
    ///Calling removeItem(withId id: ItemType.ID) for each element in ids
    func removeRangeOfItems(withIds ids: some Collection<ItemType.ID>) {
        ids.forEach({self.removeItem(withId: $0)})
    }
}

extension FileCache {
    enum FileCacheError: Error {
        case SerializationError
        case DeserializationError
    }
    
    func saveAsJsonFile(withURL url: URL) throws {
        let json = self.itemsById.values.map({$0.json})
        
        if !JSONSerialization.isValidJSONObject(json) {
            throw FileCacheError.SerializationError
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            throw FileCacheError.SerializationError
        }
        
        do {
            try jsonData.write(to: url)
        } catch {
            throw error
        }
    }
    
    func loadFromJsonFile(withURL url: URL) throws {
        var jsonData: Data
        do {
            jsonData = try Data(contentsOf: url)
        } catch {
            throw error
        }
        
        guard let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            throw FileCacheError.DeserializationError
        }
        
        let items = jsonArray.compactMap{ItemType.parse(json: $0)}
        removeRangeOfItems(withIds: itemsById.keys)
        setRange(ofItems: items)
    }
    
    func saveAsCsvFile(withURL url: URL) throws {
        guard let csvData = self.itemsById.values.map({$0.csv}).joined(separator: "\n").data(using: .utf8) else {
            throw FileCacheError.SerializationError
        }
        
        do {
            try csvData.write(to: url)
        } catch {
            throw error
        }
    }
    
    func loadFromCsvFile(withURL url: URL) throws {
        var csvData: Data
        do {
            csvData = try Data(contentsOf: url)
        } catch {
            throw error
        }
        
        guard let csv = String(data: csvData, encoding: .utf8) else {
            throw FileCacheError.DeserializationError
        }
        
        let csvItemArray = csv.split(separator: "\n")
        
        let items = csvItemArray.compactMap{ItemType.parse(csv: String($0))}
        removeRangeOfItems(withIds: itemsById.keys)
        setRange(ofItems: items)
    }
}
