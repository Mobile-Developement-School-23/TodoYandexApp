//
//  TodoDetailsScrollView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import UIKit

class TodoDetailsScrollView: UIScrollView, DeactevatedView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateViewWithAnchors(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        
        guard let top = top, let bot = bottom, let leading = leading, let trailing = trailing else {
            return
        }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: top),
            leadingAnchor.constraint(equalTo: leading),
            trailingAnchor.constraint(equalTo: trailing),
            bottomAnchor.constraint(equalTo: bot)
        ])
    }
    
    private func configureSubviews() {
        let stackView = TodoDetailsStackView()
        addSubview(stackView)
        stackView.activateViewWithAnchors(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, width: widthAnchor)
    }
}
