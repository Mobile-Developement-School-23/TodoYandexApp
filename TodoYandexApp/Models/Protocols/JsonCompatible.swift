//
//  JsonCompatible.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 15.06.23.
//

import Foundation

protocol JsonCompatible {
    var json: Any { get }
    static func parse(json: Any) -> Self?
}
