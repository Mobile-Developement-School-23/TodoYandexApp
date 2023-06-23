//
//  TodoDetailsScrollView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import UIKit

class TodoDetailsScrollView: UIScrollView {
    func setup(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
}
