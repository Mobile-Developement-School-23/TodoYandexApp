//
//  TodoNavigationView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 22.06.23.
//

import UIKit

class TodoDetailsNavigationView: UIView, DeactivatedView {
    public var delegate: TodoDetailsNavigationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateViewWithAnchors(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        
        guard let leading = leading, let trailing = trailing, let top = top else {
            return
        }
        
        leadingAnchor.constraint(equalTo: leading).isActive = true
        trailingAnchor.constraint(equalTo: trailing).isActive = true
        topAnchor.constraint(equalTo: top).isActive = true
        heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func configureSubviews() {
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.backgroundColor = .none
        cancel.setTitle("Отменить", for: .normal)
        cancel.setTitleColor(AssetsColors.colorBlue, for: .normal)
        cancel.addTarget(self, action: #selector(closeButtonClicked), for: .touchDown)
        addSubview(cancel)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Дело"
        label.textColor = AssetsColors.labelPrimary
        label.font = AssetsFonts.headline
        addSubview(label)
        
        let save = UIButton()
        save.translatesAutoresizingMaskIntoConstraints = false
        save.backgroundColor = .none
        save.setTitle("Сохранить", for: .normal)
        save.titleLabel?.font = AssetsFonts.headline
        save.setTitleColor(AssetsColors.colorBlue, for: .normal)
        save.setTitleColor(AssetsColors.labelTertiary, for: .disabled)
        save.addTarget(self, action: #selector(saveButtonClicked), for: .touchDown)
        addSubview(save)
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        save.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cancel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        save.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cancel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc private func saveButtonClicked() {
        delegate?.saveButtonClicked()
    }
    
    @objc private func closeButtonClicked() {
        delegate?.closeButtonClicked()
    }
}

protocol TodoDetailsNavigationViewDelegate {
    func closeButtonClicked()
    
    func saveButtonClicked()
}
