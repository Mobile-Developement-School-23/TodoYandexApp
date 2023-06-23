//
//  TodoDetailsStackView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import UIKit

class TodoDetailsStackView: UIStackView {
    func setup(_ scrollView: UIScrollView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: scrollView.topAnchor),
            leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        axis = NSLayoutConstraint.Axis.vertical
        distribution = UIStackView.Distribution.equalSpacing
        alignment = UIStackView.Alignment.center
        spacing = LayoutValues.spacing
    }
}
