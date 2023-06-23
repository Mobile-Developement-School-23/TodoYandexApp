//
//  ViewController.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 12.06.23.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AssetsColors.backPrimary
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Open details", for: .normal)
        button.addTarget(self, action: #selector(onButtonClick), for: .touchDown)
        view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    @objc private func onButtonClick() {
        present(TodoDetailsViewController(), animated: true)
    }
}

