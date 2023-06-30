//
//  TodoDetailsSegmentedControl.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import UIKit

class TodoDetailsSegmentedControlWithLabel: UIView {
    private weak var viewModel: TodoDetailsViewModel?
    private var segmentedControl: StyledSegmentedControl!
    
    init(frame: CGRect = CGRect(), viewModel: TodoDetailsViewModel?) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelectedKey(_ key: Int) {
        segmentedControl.selectedSegmentIndex = key
    }
    
    private func getSegmentedControl() -> UISegmentedControl {
        let items = [
            AssetsImages.arrowDownImage,
            "нет",
            AssetsImages.exclamationImage] as [Any]
        
        segmentedControl = StyledSegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = AssetsColors.supportOverlay
        segmentedControl.accessibilityIgnoresInvertColors = true
        segmentedControl.selectedSegmentTintColor = AssetsColors.backElevated
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        return segmentedControl
    }
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Важность"
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
    
    @objc private func segmentedControlValueChanged(_ view: UISegmentedControl) {
        guard let viewModel = viewModel else {
            return
        }
        
        switch view.selectedSegmentIndex {
        case 0:
            if viewModel.importance != .low {
                viewModel.onImportanceChanged(.low)
            }
            break
        case 2:
            if viewModel.importance != .important {
                viewModel.onImportanceChanged(.important)
            }
            break
        default:
            if viewModel.importance != .basic {
                viewModel.onImportanceChanged(.basic)
            }
            break
        }
    }
}
