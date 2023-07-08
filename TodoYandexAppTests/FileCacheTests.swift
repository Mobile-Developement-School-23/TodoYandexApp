//
//  FileCacheTests.swift
//  TodoYandexAppTests
//
//  Created by Илья Колесников on 16.06.23.
//

import XCTest
import FileCachePackage

final class FileCacheTests: XCTestCase {
    func testSetAndRemove() {
        let fileCache = FileCache<TodoItem>()
        let item1 = TodoItem(id: "122", text: "Test text")
        let item2 = TodoItem(id: "123", text: "Another text")
        let item3 = TodoItem(id: "123", text: "Another text text")

        fileCache.set(item: item1)
        fileCache.set(item: item2)
        XCTAssertEqual(fileCache.itemsById.count, 2)

        fileCache.set(item: item1)
        XCTAssertEqual(fileCache.itemsById.count, 2)

        fileCache.set(item: item3)
        XCTAssertEqual(fileCache.itemsById.count, 2)

        fileCache.removeItem(withId: "0")
        XCTAssertEqual(fileCache.itemsById.count, 2)

        fileCache.removeItem(withId: "123")
        XCTAssertEqual(fileCache.itemsById.count, 1)

        fileCache.remove(item: item3)
        XCTAssertEqual(fileCache.itemsById.count, 1)

        fileCache.remove(item: item1)
        XCTAssertEqual(fileCache.itemsById.count, 0)
    }

    func testFileSaveAndLoad() {
        let fileCache = FileCache<TodoItem>()
        let item1 = TodoItem(text: "Test text")
        let item2 = TodoItem(id: "123", text: "Test text", importance: .important,
                             deadline: Date.now.addingTimeInterval(7200), done: false, createdAt: Date.now,
                             changedAt: Date.now.addingTimeInterval(3600))
        fileCache.set(item: item1)
        fileCache.set(item: item2)

        let csvUrl = URL.documentsDirectory.appending(component: "todo.csv")
        let jsonUrl = URL.documentsDirectory.appending(component: "todo.json")

        XCTAssertNoThrow(try fileCache.saveAsCsvFile(withURL: csvUrl))
        XCTAssertNoThrow(try fileCache.saveAsJsonFile(withURL: jsonUrl))

        let csv = try? String(contentsOf: csvUrl)
        let json = try? String(contentsOf: jsonUrl)

        XCTAssertNotNil(csv)
        XCTAssertNotNil(json)

        guard csv != nil && json != nil else {
            return
        }

        let fileCacheCsv = FileCache<TodoItem>()
        let fileCacheJson = FileCache<TodoItem>()

        XCTAssertNoThrow(try fileCacheCsv.loadFromCsvFile(withURL: csvUrl))
        XCTAssertNoThrow(try fileCacheJson.loadFromJsonFile(withURL: jsonUrl))

        XCTAssertEqual(fileCache.itemsById, fileCacheCsv.itemsById)
        XCTAssertEqual(fileCache.itemsById, fileCacheJson.itemsById)
        XCTAssertEqual(fileCacheCsv.itemsById, fileCacheJson.itemsById)
    }
}
