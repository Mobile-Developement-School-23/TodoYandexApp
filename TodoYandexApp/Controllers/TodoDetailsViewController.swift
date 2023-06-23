//
//  TodoDetailsViewController.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 20.06.23.
//

import UIKit

class TodoDetailsViewController: UIViewController, TodoDetailsNavigationViewDelegate {
    private var scrollView: TodoDetailsScrollView!
    private let navigationView = TodoDetailsNavigationView()
    private let viewModel = TodoDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        viewModel.mainHandler = self
        
        scrollView = TodoDetailsScrollView(viewModel: viewModel)
        setupView()
        
        scrollView.activateViewWithAnchors(top: view.layoutMarginsGuide.topAnchor, bottom: view.keyboardLayoutGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, trailing: view.layoutMarginsGuide.trailingAnchor)
        
        view.addSubview(navigationView)
        navigationView.activateViewWithAnchors(top: view.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, trailing: view.layoutMarginsGuide.trailingAnchor)
        navigationView.delegate = self
        
        viewModel.loadTodoItem()
    }
    
    func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    func saveButtonClicked() {
        viewModel.saveChanges()
        closeButtonClicked()
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

extension TodoDetailsViewController: TodoDetailsViewModelMainHandler {
    func onFileSaveError() {
        print("OOPS, FILE NOT SAVED")
    }
    
    func onTodoItemDeleted() {
        closeButtonClicked()
    }
}
