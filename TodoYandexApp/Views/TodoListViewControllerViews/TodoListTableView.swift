//
//  TodoListTableView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 26.06.23.
//

import UIKit

class TodoListTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var data: [TodoItem]? = [TodoItem]()

    override init(frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        translatesAutoresizingMaskIntoConstraints = false
        isScrollEnabled = false
        backgroundColor = .none
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        self.register(TodoListCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data![indexPath.row].text
        return cell
    }
}
