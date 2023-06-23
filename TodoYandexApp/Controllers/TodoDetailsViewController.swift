//
//  TodoDetailsViewController.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 20.06.23.
//

import UIKit

class TodoDetailsViewController: UIViewController, TodoDetailsCalendarSwitchDeleate {
    private var scrollView: TodoDetailsScrollView!
    private var textInputView = UIExpandingTextView()
    private var stackView: TodoDetailsStackView!
    private var fieldsStackView: VerticalStackLayoutView!
    private let calendarView = UICalendarView()
    private let deleteButton = TodoDetailsDeleteButton()
    private let navigationView = TodoDetailsNavigationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        scrollView = TodoDetailsScrollView()
        setupView()
        
        stackView = TodoDetailsStackView()
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(textInputView)
        stackView.addSubview(textInputView)
        
        scrollView.setup(view)
        stackView.setup(scrollView)
        setupTextInputView()
        appendAndSetupFields()
        deleteButton.setup(stackView)
        navigationView.setup(view)
    }
    
    func onValueChanged(value: Bool) {
        if value {
            _ = fieldsStackView.addSeparatedSubview(calendarView, animated: true)
        } else {
            _ = fieldsStackView.removeSeparatedSubview(calendarView, animated: true)
        }
    }
    
    private func setupView() {
        view.backgroundColor = AssetsColors.backPrimary
        view.layoutMargins = LayoutValues.padding
        view.layoutMargins.bottom = 0
        view.layoutMargins.top += 56
        view.layoutMarginsDidChange()
        view.addSubview(scrollView)
        
        navigationItem.title = "To do"
        let leftItem = UIBarButtonItem()
        leftItem.title = "Close"
        let rightItem = UIBarButtonItem()
        leftItem.title = "Save"
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func onTextViewChabged(_ view: UITextView) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height / 2)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    private func appendAndSetupFields() {
        fieldsStackView = VerticalStackLayoutView()
        let importance = TodoDetailsSegmentedControlWithLabel()
        let calendarSwitch = TodoDetailsCalendarSwitch()
        fieldsStackView = VerticalStackLayoutView()
            .setPadding(LayoutValues.padding)
            .setSeparatorColor(AssetsColors.supportSeparator)
            .setSpacing(LayoutValues.spacing)
            .withBackgroundColor(AssetsColors.backSecondary)
            .addSeparatedSubview(importance)
            .addSeparatedSubview(calendarSwitch)
            .setRadius(LayoutValues.cornerRadius)
        
        stackView.addArrangedSubview(fieldsStackView)
        stackView.addSubview(fieldsStackView)
        importance.setup()
        calendarSwitch.setup()
        calendarSwitch.switchDelegate = self
        fieldsStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
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
        _ = textInputView.addTextDidChangeHandler(onTextViewChabged(_:))
    }
}
