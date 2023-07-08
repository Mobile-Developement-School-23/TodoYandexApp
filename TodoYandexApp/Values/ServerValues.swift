//
//  ServerValues.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 5.07.23.
//

import Foundation

class ServerValues {
    static let baseUrlString = "https://beta.mrdekk.ru/todobackend/"
    static let listUrlString = baseUrlString + "list/"

    static let baseUrl = URL(string: baseUrlString)!
    static let listUrl = URL(string: listUrlString)!

    static let authorizationHeaderValue = "Bearer oratorlike" // Вообще были планы вынести это в конфиг файл,
    // который бы находился в гитигноре, но да кому нужны все эти заморочки)))
}
