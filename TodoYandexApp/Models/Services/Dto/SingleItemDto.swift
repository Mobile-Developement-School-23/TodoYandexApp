//
//  ItemResponseData.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 7.07.23.
//

import Foundation

struct SingleItemDto: Codable {
    let status: String
    let element: TodoItemDto
    let revision: Int32
}
