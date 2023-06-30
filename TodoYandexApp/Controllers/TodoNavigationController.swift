//
//  TodoNavigationController.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 26.06.23.
//

import UIKit

class TodoNavigationController: UINavigationController {
    override func viewDidLoad() {
        navigationBar.prefersLargeTitles = true
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 14
        UINavigationBar.appearance().largeTitleTextAttributes =
        [NSAttributedString.Key.foregroundColor: AssetsColors.labelPrimary, NSAttributedString.Key.font: AssetsFonts.largeTitle, NSAttributedString.Key.paragraphStyle : style]
        pushViewController(TodoListViewController(), animated: false)
    }
}
