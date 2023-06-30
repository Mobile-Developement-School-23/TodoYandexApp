//
//  TodoDetailsTextInputView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 23.06.23.
//

import UIKit

class TodoDetailsTextInputView: UIExpandingTextView, DeactivatedView {
    override init(frame: CGRect = CGRect(), textContainer: NSTextContainer?) {
        super.init(textContainer: textContainer)

        font = AssetsFonts.body
        placeholder = "Что надо сделать?"
        textContainerInset = LayoutValues.padding
        defaultTextColor = AssetsColors.labelPrimary
        placeholderColor = AssetsColors.labelTertiary
        layer.cornerRadius = LayoutValues.cornerRadius
        backgroundColor = AssetsColors.backSecondary
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func activateViewWithAnchors(top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil,
                                 leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil,
                                 width: NSLayoutDimension?, height: NSLayoutDimension? = nil,
                                 centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {

        guard let width = width else {
            return
        }

        widthAnchor.constraint(equalTo: width).isActive = true
    }
}
