//
//  ViewController.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 12.06.23.
//

import UIKit
import CocoaLumberjackSwift
import FileCachePackage

class TodoListViewController: UIViewController {
    private let tableView = TodoListTableView()
    private let tableViewCover = UIView()
    private var briefingView: TodoListBriefingView!
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    var serverModel: ServerModelSynchronizer!

    var data = [TodoItem]()
    lazy var fileCache = FileCache<TodoItem>()

    override func viewDidLoad() {
        super.viewDidLoad()
        DDLogDebug("List view controller loaded")
        configureController()
        configureView()
        prepareModel()
    }
}

// Configuration is here
extension TodoListViewController {
    private func prepareModel() {
        try? fileCache.loadFromJsonFile(withURL: ModelValues.todosUrl)
        serverModel = ServerModelSynchronizer(fileCache: fileCache)
        serverModel.controller = self
        serverModel.loadModel()
        onItemsChanged()
    }

    private func configureView() {
        view.backgroundColor = AssetsColors.backPrimary
        view.layoutMargins = LayoutValues.padding
        navigationController?.navigationBar.barTintColor = AssetsColors.supportNavBarBlur

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = true
        tableView.estimatedRowHeight = 56

        appendTableView()
        appendTodoBriefing()
        appendAddTodoButton()

        appendTableViewCover()
    }

    private func appendTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func appendTableViewCover() {
        view.addSubview(tableViewCover)
        tableViewCover.translatesAutoresizingMaskIntoConstraints = false
        tableViewCover.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        tableViewCover.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
        tableViewCover.topAnchor.constraint(equalTo: tableView.tableHeaderView!.bottomAnchor).isActive = true
        tableViewCover.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        tableViewCover.isUserInteractionEnabled = false
        tableViewCover.backgroundColor = view.backgroundColor
        tableViewCover.alpha = 0
    }

    private func appendAddTodoButton() {
        let button = TodoListAddButton()
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.addTarget(self, action: #selector(onButtonClick), for: .touchDown)
    }

    private func appendTodoBriefing() {
        briefingView = TodoListBriefingView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        tableView.tableHeaderView = briefingView
        briefingView.translatesAutoresizingMaskIntoConstraints = true
        briefingView.autoresizingMask = [.flexibleWidth]
        briefingView.backgroundColor = .none
        briefingView.switchButtonDelegate = onCompletedSwitchClicked
    }

    private func configureController() {
        navigationItem.title = "Мои дела"
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: activityIndicator), animated: true)
        tableView.register(TodoListCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
    }
}

// Calls are here
extension TodoListViewController {
    func reloadData() {
        briefingView.setCompletedCount(fileCache.itemsById.values.filter {$0.done}.count)
        if briefingView.isButtonOn {
            data = fileCache.itemsById.values.sorted(by: {$0.createdAt > $1.createdAt})
        } else {
            data = fileCache.itemsById.values.filter {!$0.done}.sorted(by: {$0.createdAt > $1.createdAt})
        }

        UIView.animate(withDuration: 0.15, animations: {
            self.tableViewCover.alpha = 1
        }, completion: {_ in self.tableView.reloadData();self.tableViewCover.alpha = 0})
    }

    func setCellCorners(cell: UITableViewCell, indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.row == data.count {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners =
            [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == data.count {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
        }
    }
}
