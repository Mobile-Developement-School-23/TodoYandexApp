//
//  TodoNavigationView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 22.06.23.
//

import UIKit

class TodoDetailsNavigationView: UIView {
    func setup(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self)
        leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.backgroundColor = .none
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(AssetsColors.colorBlue, for: .normal)
        addSubview(cancel)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "To do"
        label.textColor = AssetsColors.labelPrimary
        label.font = AssetsFonts.headline
        addSubview(label)
        
        let save = UIButton()
        save.translatesAutoresizingMaskIntoConstraints = false
        save.backgroundColor = .none
        save.setTitle("Save", for: .normal)
        save.titleLabel?.font = AssetsFonts.headline
        save.setTitleColor(AssetsColors.colorBlue, for: .normal)
        save.setTitleColor(AssetsColors.labelTertiary, for: .disabled)
        addSubview(save)
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        save.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cancel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        save.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cancel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    }
}
