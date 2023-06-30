//
//  TodoListAddButton.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 26.06.23.
//

import UIKit

class TodoListAddButton: UIButton {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 44)
        setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: configuration)?.withTintColor(AssetsColors.colorBlue), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
