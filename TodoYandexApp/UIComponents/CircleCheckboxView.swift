//
//  CircleCheckboxView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 28.06.23.
//

import UIKit

open class CircleCheckboxView: UIButton {
    public private(set) var isError = false
    public private(set) var isOn = false
    
    public var errorImage: UIImage = UIImage()
    public var defaultImage: UIImage = UIImage()
    public var checkedImage: UIImage = UIImage()
    public var delegate: ((Bool) -> Void)?
    
    public override init(frame: CGRect = CGRect(x: 0, y: 0, width: 24, height: 24)) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setIsOn(_ isOn: Bool) {
        self.isOn = isOn
        updateImage()
    }
    
    public func setIsError(_ isError: Bool) {
        self.isError = isError
        updateImage()
    }
    
    private func configureSubviews() {
        setImage(defaultImage, for: .normal)
        addTarget(self, action: #selector(onClick), for: .touchDown)
    }
    
    private func updateImage() {
        if isOn {
            setImage(checkedImage, for: .normal)
        } else {
            if isError {
                setImage(errorImage, for: .normal)
            } else {
                setImage(defaultImage, for: .normal)
            }
        }
    }
    
    @objc private func onClick() {
        setIsOn(!isOn)
        if delegate != nil {
            delegate!(isOn)
        }
    }
}
