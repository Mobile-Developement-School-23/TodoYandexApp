//
//  TodoDetailsViewModel.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 23.06.23.
//

import UIKit

class TodoDetailsViewModel {
    private let loadUrl: URL = URL.documentsDirectory.appending(component: "details.json")
    private var todoItem: TodoItem?
    private var stringColor: String?

    private(set) var text: String = ""
    private(set) var deadline: Date?
    private(set) var importance: TodoItemImportance = .basic
    private(set) var isSaved = false
    private(set) var color: UIColor?

    private var delegates = [() -> Void]()

    public weak var controller: TodoDetailsViewController?

    func setItem(_ item: TodoItem?) {
        todoItem = item
        isSaved = todoItem != nil
        text = todoItem?.text ?? ""
        deadline = todoItem?.deadline
        importance = todoItem?.importance ?? .basic
        stringColor = todoItem?.color

        if stringColor != nil {
            color = UIColor(hexString: stringColor!) ?? AssetsColors.labelPrimary
        }
        notifyDelegates()
    }

    func saveChanges() {
        self.todoItem = makeTodoItem()
    }

    @MainActor func deleteTodoItem() {
        controller?.onTodoItemDeleted()
    }

    func onTextChanged(_ text: String) {
        self.text = text
        notifyDelegates()
    }

    func onDateChanged(_ date: Date?) {
        self.deadline = date
        notifyDelegates()
    }

    func onImportanceChanged(_ importance: TodoItemImportance) {
        self.importance = importance
        notifyDelegates()
    }

    func onColorChanged(_ color: UIColor?) {
        if color != AssetsColors.labelPrimary {
            self.color = color
            stringColor = color?.htmlRGBColor
        } else {
            self.color = nil
            stringColor = nil
        }
        notifyDelegates()
    }

    func notifyDelegates() {
        for delegate in delegates {
            delegate()
        }
    }

    func addDelegate(_ delegate: @escaping () -> Void) {
        delegates.append(delegate)
    }

    func makeTodoItem() -> TodoItem {
        guard let todoItem = todoItem else {
            let item = TodoItem(text: text, importance: importance, deadline: deadline, color: stringColor)
            return item
        }

        let item = TodoItem(id: todoItem.id, text: text, importance: importance, deadline: deadline,
                            done: todoItem.done, createdAt: todoItem.createdAt, changedAt: Date.now, color: stringColor)
        return item
    }
}

@MainActor
protocol TodoDetailsViewModelMainHandler {
    func onFileSaveError()

    func onTodoItemDeleted()
}
