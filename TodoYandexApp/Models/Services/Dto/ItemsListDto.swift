//
//  ItemsListResponseData.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 6.07.23.
//

import Foundation

struct ItemsListDto: Codable {
    let status: String
    let list: [TodoItemDto]
    let revision: Int32
}
