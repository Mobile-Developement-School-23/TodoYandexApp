//
//  CsvCompatible.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 16.06.23.
//

import Foundation

protocol CsvCompatible {
    var csv: String { get }
    static func parse(csv: String) -> Self?
}
