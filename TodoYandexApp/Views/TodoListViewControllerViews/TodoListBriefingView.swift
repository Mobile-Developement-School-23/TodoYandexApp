//
//  TodoListBriefingView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 26.06.23.
//

import UIKit

class TodoListBriefingView: UIView {
    typealias ButtonDelegate = (Bool) -> Void

    private lazy var labelView = UILabel()
    private lazy var buttonView = UIButton()
    private(set) var isButtonOn = false

    var switchButtonDelegate: ButtonDelegate?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        layoutMargins = LayoutValues.padding
        layoutMargins.top = 0
        layoutMargins.bottom = 0
        layoutMarginsDidChange()

        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCompletedCount(_ count: Int) {
        labelView.text = "Выполнено — \(count)"
    }

    func setButtonState(_ isOn: Bool) {
        isButtonOn = isOn
        if switchButtonDelegate != nil {
            switchButtonDelegate!(isOn)
        }
        if !isOn {
            buttonView.setTitle("Показать", for: .normal)
        } else {
            buttonView.setTitle("Скрыть", for: .normal)
        }
    }

    private func configureSubviews() {
        appendLabelView()
        appendButtonView()

        heightAnchor.constraint(equalTo: buttonView.heightAnchor).isActive = true
    }

    private func appendLabelView() {
        labelView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelView)
        labelView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        labelView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        labelView.font = AssetsFonts.subhead
        labelView.textColor = AssetsColors.labelTertiary
        setCompletedCount(0)
    }

    private func appendButtonView() {
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonView)
        buttonView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        buttonView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        buttonView.titleLabel?.font = AssetsFonts.boldSubhead
        buttonView.setTitleColor(AssetsColors.colorBlue, for: .normal)
        setButtonState(false)
        buttonView.addTarget(self, action: #selector(onButtonClicked), for: .touchDown)
    }

    @objc private func onButtonClicked() {
        setButtonState(!isButtonOn)
    }
}
