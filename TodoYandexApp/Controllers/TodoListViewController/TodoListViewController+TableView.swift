//
//  TodoListViewController+TableView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 30.06.23.
//

import UIKit

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != data.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoListCell
            guard let cell = cell else {
                fatalError("Cell not conforms its type")
            }
            let todo = data[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.onTodoChanged = onDetailedTodoItemChanged(item:)
            cell.rerenderWith(item: todo)
            setCellCorners(cell: cell, indexPath: indexPath)
            cell.backgroundColor = AssetsColors.backSecondary
            return cell
        } else {
            var configuration = UIListContentConfiguration.cell()
            let string = NSMutableAttributedString(string: "Новое")
            string.addAttribute(NSAttributedString.Key.foregroundColor, value: AssetsColors.labelTertiary,
                                range: NSRange(location: 0, length: string.length))
            string.addAttribute(NSAttributedString.Key.font, value: AssetsFonts.body,
                                range: NSRange(location: 0, length: string.length))
            configuration.attributedText = string
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            setCellCorners(cell: cell, indexPath: indexPath)
            cell.backgroundColor = AssetsColors.backSecondary
            cell.contentConfiguration = configuration
            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
            cell.layoutMargins = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.15, animations: {
            cell.alpha = 1
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == data.count {
            onButtonClick()
            return
        }
        let details = TodoDetailsViewController()
        present(details, animated: true)
        details.setTodoItem(data[indexPath.row])
        details.setCallbacks(saved: onDetailedTodoItemChanged, deleted: onDetailedTodoItemDeleted)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == data.count {
            return nil
        }
        let infoAction = UIContextualAction(style: .normal, title: nil,
                                            handler: { [weak self] (_, _, _) in
            self?.tableView(tableView, didSelectRowAt: indexPath)
        })

        infoAction.image = AssetsImages.infoImage
        infoAction.backgroundColor = AssetsColors.colorGrayLight

        let deleteAction = UIContextualAction(style: .normal, title: nil,
                                              handler: { [weak self] (_, _, _) in
            self?.onDetailedTodoItemDeleted(item: self!.data[indexPath.row])
        })

        deleteAction.image = AssetsImages.trashImage
        deleteAction.backgroundColor = AssetsColors.colorRed

        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == data.count {
            return nil
        }
        let action = UIContextualAction(style: .normal, title: nil,
                                        handler: { (_, _, _) in
            let cell = tableView.cellForRow(at: indexPath) as? TodoListCell
            guard let cell = cell else {
                fatalError("Cell not conforms its type")
            }
            cell.checkbox.setIsOn(!cell.checkbox.isOn)
            cell.onCheckboxValueChanged(cell.checkbox.isOn)
        })

        action.image = AssetsImages.invertedCheckedImage
        action.backgroundColor = AssetsColors.colorGreen

        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == data.count {
            return 56
        } else {
            return UITableView.automaticDimension
        }
    }
}
