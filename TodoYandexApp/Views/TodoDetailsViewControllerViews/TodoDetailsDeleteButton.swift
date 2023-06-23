//
//  TodoDetailsDeleteButton.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 22.06.23.
//

import UIKit

class TodoDetailsDeleteButton: UIButton, DeactevatedView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("Delete", for: .normal)
        setTitle("Delete", for: .disabled)
        backgroundColor = AssetsColors.backSecondary
        setTitleColor(AssetsColors.colorRed, for: .normal)
        setTitleColor(AssetsColors.labelTertiary, for: .disabled)
        layer.cornerRadius = LayoutValues.cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func activateViewWithAnchors(top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, width: NSLayoutDimension?, height: NSLayoutDimension? = nil, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        
        guard let width = width else {
            return
        }
        
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        widthAnchor.constraint(equalTo: width).isActive = true
    }
    
    func setup(_ stackView: UIStackView) {
        stackView.addArrangedSubview(self)
        stackView.addSubview(self)
    }
}
