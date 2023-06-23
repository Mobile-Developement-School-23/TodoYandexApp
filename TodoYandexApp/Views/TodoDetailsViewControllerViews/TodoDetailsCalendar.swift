//
//  TodoDetailsCalendar.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 22.06.23.
//

import UIKit

class TodoDetailsCalendarSwitch: UIView {
    private let leftStackView = UIStackView()
    private let dateLabel = UILabel()
    var switchDelegate: TodoDetailsCalendarSwitchDeleate?
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Deadline"
        label.font = AssetsFonts.body
        label.textColor = AssetsColors.labelPrimary
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "12 june 2003"
        dateLabel.font = AssetsFonts.footnote
        dateLabel.textColor = AssetsColors.colorBlue
        
        leftStackView.axis = .vertical
        
        addSubview(switchControl)
        addSubview(leftStackView)
        leftStackView.addArrangedSubview(label)
        leftStackView.addArrangedSubview(dateLabel)
        leftStackView.addSubview(label)
        leftStackView.addSubview(dateLabel)
        dateLabel.isHidden = true
        
        heightAnchor.constraint(equalTo: switchControl.heightAnchor).isActive = true
        
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        leftStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        leftStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        switchControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    @objc private func switchChanged(switchControl: UISwitch) {
        switchDateShowing(switchControl.isOn)
        switchDelegate?.onValueChanged(value: switchControl.isOn)
    }
    
    private func switchDateShowing(_ isShowing: Bool) {
        dateLabel.isHidden = !isShowing
    }
}

protocol TodoDetailsCalendarSwitchDeleate {
    func onValueChanged(value: Bool)
}
