//
//  TodoListViewController+Callbacks.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 30.06.23.
//

import UIKit

extension TodoListViewController {
    @objc func onButtonClick() {
        let details = TodoDetailsViewController()
        present(details, animated: true)
        details.setTodoItem(nil)
        details.setCallbacks(saved: onDetailedTodoItemChanged, deleted: onDetailedTodoItemDeleted)
    }

    func onDetailedTodoItemChanged(item: TodoItem) {
        if fileCache.itemsById.keys.contains(item.id) {
            fileCache.set(item: item)
            serverModel.updateItem(item)
        } else {
            fileCache.set(item: item)
            serverModel.addItem(item)
        }
        try? fileCache.saveAsJsonFile(withURL: ModelValues.todosUrl)
        onItemsChanged()
    }

    func onDetailedTodoItemDeleted(item: TodoItem) {
        fileCache.remove(item: item)
        serverModel.deleteItem(item)
        try? fileCache.saveAsJsonFile(withURL: ModelValues.todosUrl)
        onItemsChanged()
    }

    func onCompletedSwitchClicked(_ isOn: Bool) {
        reloadData()
    }

    func onItemsChanged() {
        reloadData()
    }
}
