//
//  TodoDetailsViewController.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 20.06.23.
//

import UIKit

class TodoDetailsViewController: UIViewController {
    private var scrollView: TodoDetailsScrollView!
    private var textInputView = UIExpandingTextView()
    private var fieldsStackView: VerticalStackLayoutView!
    private let calendarView = UICalendarView()
    private let deleteButton = TodoDetailsDeleteButton()
    private let navigationView = TodoDetailsNavigationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        scrollView = TodoDetailsScrollView()
        setupView()
        
        scrollView.activateViewWithAnchors(top: view.layoutMarginsGuide.topAnchor, bottom: view.keyboardLayoutGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, trailing: view.layoutMarginsGuide.trailingAnchor)
        
        view.addSubview(navigationView)
        navigationView.activateViewWithAnchors(top: view.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, trailing: view.layoutMarginsGuide.trailingAnchor)
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
}
