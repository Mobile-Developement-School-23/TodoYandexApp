//
//  TodoDetailsStackView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import UIKit

class TodoDetailsStackView: UIStackView, DeactevatedView, TodoDetailsCalendarSwitchDeleate {
    private var fieldsStackView: VerticalStackLayoutView!
    private var calendarSwitch: TodoDetailsCalendarSwitch!
    private let calendarView = UICalendarView()
    
    override init(frame: CGRect = CGRect()) {
        super.init(frame: frame)
        axis = NSLayoutConstraint.Axis.vertical
        distribution = UIStackView.Distribution.equalSpacing
        alignment = UIStackView.Alignment.center
        spacing = LayoutValues.spacing
        translatesAutoresizingMaskIntoConstraints = false
        configureSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateViewWithAnchors(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, width: NSLayoutDimension?, height: NSLayoutDimension? = nil, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        
        guard let top = top, let bot = bottom, let leading = leading, let trailing = trailing, let width = width else {
            return
        }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: top),
            leadingAnchor.constraint(equalTo: leading),
            trailingAnchor.constraint(equalTo: trailing),
            bottomAnchor.constraint(equalTo: bot),
            widthAnchor.constraint(equalTo: width)
        ])
    }
    
    private func configureSubviews() {
        let textView = TodoDetailsTextInputView()
        addSubview(textView)
        addArrangedSubview(textView)
        textView.activateViewWithAnchors(width: widthAnchor)
        
        let importance = TodoDetailsSegmentedControlWithLabel()
        calendarSwitch = TodoDetailsCalendarSwitch()
        fieldsStackView = VerticalStackLayoutView()
            .setPadding(LayoutValues.padding)
            .setSeparatorColor(AssetsColors.supportSeparator)
            .setSpacing(LayoutValues.spacing)
            .withBackgroundColor(AssetsColors.backSecondary)
            .addSeparatedSubview(importance)
            .addSeparatedSubview(calendarSwitch)
            .setRadius(LayoutValues.cornerRadius)
        
        addArrangedSubview(fieldsStackView)
        addSubview(fieldsStackView)
        calendarSwitch.switchDelegate = self
        
        fieldsStackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        let deleteButton = TodoDetailsDeleteButton()
        addArrangedSubview(deleteButton)
        addSubview(deleteButton)
        deleteButton.activateViewWithAnchors(width: widthAnchor)
    }
    
    func onValueChanged(value: Bool) {
        if value {
            _ = fieldsStackView.addSeparatedSubview(calendarView, animated: true)
        } else {
            _ = fieldsStackView.removeSeparatedSubview(calendarView, animated: true)
        }
    }
}
