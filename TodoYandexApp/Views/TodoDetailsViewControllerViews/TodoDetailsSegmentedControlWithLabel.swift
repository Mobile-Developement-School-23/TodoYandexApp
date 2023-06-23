//
//  TodoDetailsSegmentedControl.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import UIKit

class TodoDetailsSegmentedControlWithLabel: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getSegmentedControl() -> UISegmentedControl {
        var config = UIImage.SymbolConfiguration(paletteColors: [AssetsColors.colorRed])
        config = config.applying(UIImage.SymbolConfiguration(weight: .bold))

        let exclamation = UIImage(systemName: "exclamationmark.2", withConfiguration: config)!.withTintColor(AssetsColors.colorRed, renderingMode: .alwaysOriginal)
                        
        let items = [
            UIImage(systemName: "arrow.down")!.withTintColor(AssetsColors.colorGray, renderingMode: .alwaysOriginal),
            "no",
            exclamation] as [Any]
        
        let segmentedControl = StyledSegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = AssetsColors.supportOverlay
        segmentedControl.accessibilityIgnoresInvertColors = true
        segmentedControl.selectedSegmentTintColor = AssetsColors.backElevated
        
        return segmentedControl
    }
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Importance"
        label.font = AssetsFonts.body
        label.textColor = AssetsColors.labelPrimary
        
        return label
    }
    
    private func configureSubviews() {
        let segmentedControl = getSegmentedControl()
        
        let label = getLabel()
        
        addSubview(segmentedControl)
        addSubview(label)
        
        heightAnchor.constraint(equalTo: segmentedControl.heightAnchor).isActive = true
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
