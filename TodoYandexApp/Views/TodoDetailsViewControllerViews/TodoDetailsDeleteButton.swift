//
//  TodoDetailsDeleteButton.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 22.06.23.
//

import UIKit

class TodoDetailsDeleteButton: UIButton {
    func setup(_ stackView: UIStackView) {
        setTitle("Delete", for: .normal)
        setTitle("Delete", for: .disabled)
        backgroundColor = AssetsColors.backSecondary
        setTitleColor(AssetsColors.colorRed, for: .normal)
        setTitleColor(AssetsColors.labelTertiary, for: .disabled)
        layer.cornerRadius = LayoutValues.cornerRadius
        stackView.addArrangedSubview(self)
        stackView.addSubview(self)
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
}
