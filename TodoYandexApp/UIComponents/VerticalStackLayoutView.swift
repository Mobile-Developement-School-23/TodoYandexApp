//
//  UIVerticalStackViewWithSeparator.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import UIKit

open class VerticalStackLayoutView: UIStackView {
    private var separatorColor: UIColor = .black

    override init(frame: CGRect = CGRect()) {
        super.init(frame: CGRect())
        isLayoutMarginsRelativeArrangement = false
        axis = NSLayoutConstraint.Axis.vertical
        distribution = UIStackView.Distribution.equalSpacing
        alignment = UIStackView.Alignment.center
    }

    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func withBackgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }

    public func addSeparatedSubview(_ subview: UIView, animated: Bool = false) -> Self {
        if !subviews.isEmpty {
            addSeparator()
        }
        subview.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(subview)
        if !animated {
            addSubview(subview)
        } else {
            UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.addSubview(subview)
            }, completion: nil)
        }

        subview.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        return self
    }

    public func removeSeparatedSubview(_ subview: UIView, animated: Bool = false) -> Self {
        if subviews.contains(subview) {
            removeArrangedSubview(subview)
            if !animated {
                subview.removeFromSuperview()
            } else {
                UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                  subview.removeFromSuperview()
                }, completion: nil)
            }
            if !subviews.isEmpty, let separator = subviews.last {
                removeArrangedSubview(separator)
                separator.removeFromSuperview()
            }
        }

        return self
    }

    public func setSeparatorColor(_ color: UIColor) -> Self {
        separatorColor = color
        return self
    }

    public func setSpacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

    public func setPadding(_ padding: UIEdgeInsets) -> Self {
        layoutMargins = padding
        isLayoutMarginsRelativeArrangement = true
        return self
    }

    public func setRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        return self
    }

    private func addSeparator() {
        let separator = UIView()
        addArrangedSubview(separator)
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = separatorColor
        separator.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
    }
}
