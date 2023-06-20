//
//  TodoItemTests.swift
//  TodoYandexAppTests
//
//  Created by Илья Колесников on 13.06.23.
//

import XCTest

final class TodoItemTests: XCTestCase {
    //TodoItem
    func testInit() {
        let testText = "Test text"
        let item1 = TodoItem(text: testText)
        
        XCTAssertNotNil(UUID(uuidString: item1.id))
        XCTAssertEqual(item1.createdAt.timeIntervalSince1970, Date.now.timeIntervalSince1970, accuracy: TimeInterval(1))
        XCTAssertEqual(item1.text, testText)
        XCTAssertEqual(item1.importance, .basic)
        XCTAssertEqual(item1.deadline, nil)
        XCTAssertEqual(item1.changedAt, nil)
        XCTAssertEqual(item1.done, false)
        
        let now = Date.now
        let item2 = TodoItem(id: "1", text: "1", importance: .low, deadline: now, done: true, createdAt: now, changedAt: now)
        
        XCTAssertEqual(item2.id, "1")
        XCTAssertEqual(item2.createdAt, now)
        XCTAssertEqual(item2.text, "1")
        XCTAssertEqual(item2.importance, .low)
        XCTAssertEqual(item2.deadline, now)
        XCTAssertEqual(item2.changedAt, now)
        XCTAssertEqual(item2.done, true)
    }
    
    func testTwoItemsComparing() {
        let now = Date.now
        let item1 = TodoItem(id: "123", text: "Test text", importance: .important, deadline: now.addingTimeInterval(7200), done: false, createdAt: now, changedAt: now.addingTimeInterval(3600))
        let item2 = TodoItem(id: "123", text: "Test text", importance: .important, deadline: now.addingTimeInterval(7200), done: false, createdAt: now, changedAt: now.addingTimeInterval(3600))
        let item3 = item1
        let item4 = TodoItem(text: "Hello")
        
        XCTAssertEqual(item1, item1)
        XCTAssertEqual(item1, item2)
        XCTAssertEqual(item1, item3)
        XCTAssertEqual(item3, item2)
        XCTAssertNotEqual(item1, item4)
    }
    //TodoItem+Json
    private func checkJsonDictsEquality(_ json1: [String: Any], _ json2: [String: Any]) -> Bool {
        return json1["id"] as? String == json2["id"] as? String && json1["text"] as? String == json2["text"] as? String && json1["done"] as? Bool == json2["done"] as? Bool && json1["importance"] as? String == json2["importance"] as? String && json1["deadline"] as? TimeInterval == json2["deadline"] as? TimeInterval && json1["createdAt"] as? TimeInterval == json2["createdAt"] as? TimeInterval && json1["changedAt"] as? TimeInterval == json2["changedAt"] as? TimeInterval
    }
    
    func testJsonParse() {
        let dateExample = Date(timeIntervalSince1970: 1686904696)
        
        let jsonString1 = "{\"id\":\"0\",\"text\":\"TestText\",\"done\":false,\"importance\":\"low\",\"deadline\":1686904696,\"createdAt\":1686904696,\"changedAt\":1686904696}"
        let jsonData1 = jsonString1.data(using: .utf8)!
        let jsonDict1 = ["id": "0", "text": "TestText", "done": false, "importance": "low", "deadline": 1686904696.0, "createdAt": 1686904696.0, "changedAt": 1686904696.0] as [String : Any]
        let item1Reference = TodoItem(id: "0", text: "TestText", importance: .low, deadline: dateExample, done: false, createdAt: dateExample, changedAt: dateExample)
        
        let stringItem1 = TodoItem.parse(json: jsonString1)
        let dataItem1 = TodoItem.parse(json: jsonData1)
        let dictItem1 = TodoItem.parse(json: jsonDict1)
        let stringItem11 = TodoItem.parse(fromString: jsonString1)
        let dataItem11 = TodoItem.parse(fromData: jsonData1)
        let dictItem11 = TodoItem.parse(fromDictionary: jsonDict1)
        XCTAssertEqual(stringItem1, item1Reference)
        XCTAssertEqual(dataItem1, item1Reference)
        XCTAssertEqual(dictItem1, item1Reference)
        XCTAssertEqual(stringItem11, item1Reference)
        XCTAssertEqual(dataItem11, item1Reference)
        XCTAssertEqual(dictItem11, item1Reference)
        
        XCTAssertNil(TodoItem.parse(fromString: "�"))
        XCTAssertNil(TodoItem.parse(fromData: "�".data(using: .utf8)!))
        XCTAssertNil(TodoItem.parse(json: 123))

        let jsonDict2 = ["id": "0", "text": "TestText", "done": false, "createdAt": 1686904696.0] as [String : Any]
        let item2Reference = TodoItem(id: "0", text: "TestText", importance: .basic, deadline: nil, done: false, createdAt: dateExample, changedAt: nil)
        let item2 = TodoItem.parse(fromDictionary: jsonDict2)
        XCTAssertEqual(item2, item2Reference)
        
        let jsonDict3 = ["id": "0", "done": false, "deadline": 1686904696.0, "createdAt": 1686904696.0, "changedAt": 1686904696.0] as [String : Any]
        let item3 = TodoItem.parse(fromDictionary: jsonDict3)
        XCTAssertNil(item3)
        
        let jsonDict4 = ["createdAt": 1686904696.0, "text": "Some text"] as [String : Any]
        let item4 = TodoItem.parse(fromDictionary: jsonDict4)
        XCTAssertNotNil(item4)
    }
    
    func testJsonSerializing() {
        let dateExample = Date(timeIntervalSince1970: 1686904696)
        
        let dictReference1 = ["id": "0", "text": "TestText", "done": false, "importance": "low", "deadline": 1686904696.0, "createdAt": 1686904696.0, "changedAt": 1686904696.0] as [String : Any]
        let item1 = TodoItem(id: "0", text: "TestText", importance: .low, deadline: dateExample, done: false, createdAt: dateExample, changedAt: dateExample)
        let json1 = item1.json as? [String: Any]
        XCTAssertTrue(checkJsonDictsEquality(json1!, dictReference1))
        
        let csvReference2 = "\"0\";\"TestText\";\"false\";\"\";\"\";\"1686904696.0\";\"\""
        let dictReference2 = ["id": "0", "text": "TestText", "done": false, "createdAt": 1686904696.0] as [String : Any]
        let item2 = TodoItem(id: "0", text: "TestText", done: false, createdAt: dateExample)
        let json2 = item2.json as? [String: Any]
        XCTAssertTrue(checkJsonDictsEquality(json2!, dictReference2))
    }
    
    func testJsonFlow() {
        let item = TodoItem(text: "Test text", importance: .important, deadline: Date.now.addingTimeInterval(7200), done: false, changedAt: Date.now.addingTimeInterval(3600))
        
        let json = item.json
        
        let jsonDict = json as? [String: Any]
        XCTAssertNotNil(jsonDict)
        
        if jsonDict == nil {
            return
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict!)
        XCTAssertNotNil(jsonDict)
        
        if jsonData == nil {
            return
        }
        
        let jsonDict2 = try? JSONSerialization.jsonObject(with: jsonData!) as? [String: Any]
        XCTAssertNotNil(jsonDict)
        if jsonDict2 != nil {
            XCTAssertTrue(JSONSerialization.isValidJSONObject(jsonDict2!))
            let item2 = TodoItem.parse(json: jsonDict2!)!
            XCTAssertEqual(item, item2)
        }
    }
    
    //TodoItemCsv
    func testCsvParse() {
        let dateExample = Date(timeIntervalSince1970: 1686904696)
        let csv1 = "0;TestText;false;low;1686904696;1686904696;1686904696"
        let item1Reference = TodoItem(id: "0", text: "TestText", importance: .low, deadline: dateExample, done: false, createdAt: dateExample, changedAt: dateExample)
        let item1 = TodoItem.parse(csv: csv1)
        XCTAssertEqual(item1, item1Reference)
        
        let csv2 = "0;TestText;false;\"\";\"\";1686904696;\"\""
        let item2Reference = TodoItem(id: "0", text: "TestText", importance: .basic, deadline: nil, done: false, createdAt: dateExample, changedAt: nil)
        let item2 = TodoItem.parse(csv: csv2)
        XCTAssertEqual(item2, item2Reference)
        
        let csv3 = "0;\"\";false;low;1686904696;1686904696;1686904696"
        let item3 = TodoItem.parse(csv: csv3)
        XCTAssertNil(item3)
        
        let csv4 = "0;TestText;false;1686904696;1686904696;1686904696"
        let item4 = TodoItem.parse(csv: csv4)
        XCTAssertNil(item4)
        
        let csv5 = "\"\";TestText;\"\";\"\";\"\";1686904696;\"\""
        let item5 = TodoItem.parse(csv: csv5)
        XCTAssertNotNil(item5)
    }
    
    func testCsvSerializing() {
        let dateExample = Date(timeIntervalSince1970: 1686904696)
        
        let csvReference1 = "\"0\";\"TestText\";\"false\";\"low\";\"1686904696.0\";\"1686904696.0\";\"1686904696.0\""
        let item1 = TodoItem(id: "0", text: "TestText", importance: .low, deadline: dateExample, done: false, createdAt: dateExample, changedAt: dateExample)
        let csv1 = item1.csv
        XCTAssertEqual(csv1, csvReference1)
        
        let csvReference2 = "\"0\";\"TestText\";\"false\";\"\";\"\";\"1686904696.0\";\"\""
        let item2 = TodoItem(id: "0", text: "TestText", importance: .basic, deadline: nil, done: false, createdAt: dateExample, changedAt: nil)
        let csv2 = item2.csv
        XCTAssertEqual(csv2, csvReference2)
    }
    
    func testCsvFlow() {
        let item = TodoItem(text: "Test text", importance: .important, deadline: Date.now.addingTimeInterval(7200), done: false, changedAt: Date.now.addingTimeInterval(3600))
        let csv = item.csv
        
        let newItem = TodoItem.parse(csv: csv)
        XCTAssertNotNil(newItem)
        XCTAssertEqual(item, newItem)
        XCTAssertEqual(csv, newItem?.csv)
    }
}
