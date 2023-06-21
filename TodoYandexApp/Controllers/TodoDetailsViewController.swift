//
//  TodoDetailsViewController.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 20.06.23.
//

import UIKit

class TodoDetailsViewController: UIViewController {
    private var scrollView = UIScrollView()
    private var textInputView = UIExpandingTextView()
    private var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(textInputView)
        stackView.addSubview(textInputView)
        
        setupScrollView()
        setupStackView()
        setupTextInputView()
    }
    
    private func setupView() {
        view.backgroundColor = AssetsColors.backPrimary
        view.layoutMargins = LayoutValues.padding
        view.layoutMargins.bottom = 0
        view.layoutMarginsDidChange()
        view.addSubview(scrollView)
    }
    
    private func setupTextInputView() {
        textInputView.font = AssetsFonts.body
        textInputView.placeholder = "What to do?"
        textInputView.textContainerInset = LayoutValues.padding
        textInputView.defaultTextColor = AssetsColors.labelPrimary
        textInputView.placeholderColor = AssetsColors.labelTertiary
        textInputView.layer.cornerRadius = LayoutValues.cornerRadius
        textInputView.backgroundColor = AssetsColors.backSecondary
        textInputView.translatesAutoresizingMaskIntoConstraints = false
        textInputView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        textInputView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = LayoutValues.spacing
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
}
