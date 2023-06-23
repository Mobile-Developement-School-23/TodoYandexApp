//
//  StyledTrippleSegmentedControl.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import UIKit

open class StyledSegmentedControl: UISegmentedControl {
    public override init(items: [Any]?) {
        super.init(items: items)
        guard let items = items else {
            return
        }
        
        for i in 0..<items.count {
            setWidth(50, forSegmentAt: i)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
