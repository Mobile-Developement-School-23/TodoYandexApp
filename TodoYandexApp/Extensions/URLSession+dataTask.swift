//
//  URLSession+dataTask.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 5.07.23.
//

import Foundation
import CocoaLumberjackSwift

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var task: URLSessionTask?
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { contination in
                task = dataTask(with: urlRequest) { data, response, error in
                    do {
                        try Task.checkCancellation()
                    } catch {
                        contination.resume(throwing: error)
                        return
                    }
                    
                    if let error = error {
                        DDLogDebug("Error while dataTask: \(error.localizedDescription)")
                        contination.resume(throwing: error)
                        return
                    }
                    
                    guard let data = data, let response = response else {
                        fatalError("Unexpectedly found nil in data or/and response in dataTask")
                    }
                    
                    contination.resume(returning: (data, response))
                }
                
                do {
                    try Task.checkCancellation()
                } catch {
                    task?.cancel()
                    contination.resume(throwing: error)
                    return
                }
                
                task?.resume()
            }
        } onCancel: { [weak task] in
            task?.cancel()
        }
    }
}
