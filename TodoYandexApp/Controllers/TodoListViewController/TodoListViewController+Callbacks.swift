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
        cache.set(item: item)
        cache.saveChanges()
        onItemsChanged()
        if cache.contains(withId: item.id) {
            serverModel.updateItem(item)
        } else {
            serverModel.addItem(item)
        }
    }

    func onDetailedTodoItemDeleted(item: TodoItem) {
        cache.remove(item: item)
        cache.saveChanges()
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
