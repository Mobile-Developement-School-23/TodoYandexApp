//
//  DeactevatedView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 23.06.23.
//

import UIKit

/// Views conforming to thish protocol needs to be activated for showing
/// Comonnly it's just activating constraints and sets isHidden to false :D
protocol DeactivatedView {
    func activateView(with constraints: [NSLayoutConstraint])
    // swiftlint:disable function_parameter_count
    func activateViewWithAnchors(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?,
                                 leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?,
                                 width: NSLayoutDimension?, height: NSLayoutDimension?,
                                 centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?)
    // swiftlint:enable function_parameter_count
}

extension DeactivatedView {
    func activateView(with constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(constraints)
    }
}
