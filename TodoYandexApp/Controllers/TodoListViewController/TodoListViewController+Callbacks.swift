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
        fileCache.set(item: item)
        try? fileCache.saveAsJsonFile(withURL: ModelValues.todosUrl)
        onItemsChanged()
        if fileCache.itemsById.keys.contains(item.id) {
            serverModel.updateItem(item)
        } else {
            serverModel.addItem(item)
        }
    }

    func onDetailedTodoItemDeleted(item: TodoItem) {
        fileCache.remove(item: item)
        try? fileCache.saveAsJsonFile(withURL: ModelValues.todosUrl)
        onItemsChanged()
        serverModel.deleteItem(item)
    }

    func onCompletedSwitchClicked(_ isOn: Bool) {
        reloadData()
    }

    func onItemsChanged() {
        reloadData()
    }
}
