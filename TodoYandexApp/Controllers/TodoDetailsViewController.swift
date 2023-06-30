//
//  TodoDetailsViewController.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 20.06.23.
//

import UIKit
import CocoaLumberjackSwift

// swiftlint:disable trailing_whitespace
class TodoDetailsViewController: UIViewController, TodoDetailsNavigationViewDelegate {
    typealias TodoDelegate = (TodoItem) -> Void
    
    private var scrollView: TodoDetailsScrollView!
    private let navigationView = TodoDetailsNavigationView()
    private var viewModel = TodoDetailsViewModel()
    private var saved: TodoDelegate?
    private var deleted: TodoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DDLogDebug("Details controller loaded")
        hideKeyboardWhenTappedAround()
        
        viewModel.controller = self
        
        scrollView = TodoDetailsScrollView(viewModel: viewModel)
        setupView()
        
        scrollView.activateViewWithAnchors(top: view.layoutMarginsGuide.topAnchor,
                                           bottom: view.keyboardLayoutGuide.topAnchor,
                                           leading: view.layoutMarginsGuide.leadingAnchor,
                                           trailing: view.layoutMarginsGuide.trailingAnchor)
        
        view.addSubview(navigationView)
        navigationView.activateViewWithAnchors(top: view.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor,
                                               trailing: view.layoutMarginsGuide.trailingAnchor)
        navigationView.delegate = self
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        saved = nil
        deleted = nil
        DDLogDebug("Details controller dismissed")
    }
    
    func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    func saveButtonClicked() {
        viewModel.saveChanges()
        guard let saved = saved else {
            closeButtonClicked()
            return
        }
        saved(viewModel.makeTodoItem())
        closeButtonClicked()
    }
    
    func setTodoItem(_ item: TodoItem?) {
        viewModel.setItem(item)
    }
    
    func setCallbacks(saved: @escaping (TodoItem) -> Void, deleted: @escaping (TodoItem) -> Void) {
        self.saved = saved
        self.deleted = deleted
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
        guard let deleted = deleted else {
            closeButtonClicked()
            return
        }
        deleted(viewModel.makeTodoItem())
        closeButtonClicked()
    }
}
// swiftlint:enable trailing_whitespace
