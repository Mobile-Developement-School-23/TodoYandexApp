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
    private var switchControl: UISwitch!
    var switchDelegate: TodoDetailsCalendarSwitchDelegate?
    var viewModel: TodoDetailsViewModel
    
    init(frame: CGRect = CGRect(), viewModel: TodoDetailsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDateValueText() {
        if viewModel.deadline != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateLabel.text = dateFormatter.string(from: viewModel.deadline!)
            dateLabel.isHidden = false
        }
    }
    
    func setValue(_ value: Bool) {
        switchControl.setOn(value, animated: true)
    }
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сделать до"
        label.font = AssetsFonts.body
        label.textColor = AssetsColors.labelPrimary
        
        return label
    }
    
    private func configureSubviews() {
        switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        let label = getLabel()
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = ""
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

protocol TodoDetailsCalendarSwitchDelegate {
    func onValueChanged(value: Bool)
}
