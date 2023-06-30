//
//  TodoDetailsSwitchingColorPicker.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 23.06.23.
//

import UIKit

// swiftlint:disable trailing_whitespace
class TodoDetailsSwitchingColorPicker: UIStackView {
    private var switchControl: UISwitch!
    private var label: UILabel!
    private var gradientView: UIImageView!
    private var container: UIView!
    private var brightnessSlider: UISlider!
    private var brightnessLayer: CALayer!
    private let viewModel: TodoDetailsViewModel
    private var colorValue: UIColor = AssetsColors.labelPrimary
    
    init(frame: CGRect = .zero, viewModel: TodoDetailsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        axis = NSLayoutConstraint.Axis.vertical
        distribution = UIStackView.Distribution.equalSpacing
        alignment = UIStackView.Alignment.center
        spacing = LayoutValues.spacing
        
        viewModel.addDelegate(onViewModelChanged)
        
        configureSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        container = UIView()
        addArrangedSubview(container)
        addSubview(container)
        
        switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        let label = getLabel()
        
        container.addSubview(switchControl)
        container.addSubview(label)
        appendGradientView()
        
        label.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        switchControl.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: switchControl.heightAnchor).isActive = true
    }
    
    @objc private func switchChanged() {
        UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.brightnessSlider.isHidden = !self.switchControl.isOn
            self.gradientView.isHidden = !self.switchControl.isOn
            self.gradientView.alpha = !self.switchControl.isOn ? 0 : 1
            self.brightnessSlider.alpha = !self.switchControl.isOn ? 0 : 1
        }, completion: {_ in self.sliderValueChanged()})
        if !switchControl.isOn {
            viewModel.onColorChanged(nil)
        }
    }
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Выбрать цвет"
        label.font = AssetsFonts.body
        label.textColor = AssetsColors.labelPrimary
        
        return label
    }
    
    private func appendGradientView() {
        gradientView = UIImageView(image: AssetsImages.gradientImage)
        addTapHandlers()
        addArrangedSubview(gradientView)
        addSubview(gradientView)
        
        gradientView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        brightnessSlider = UISlider()
        addArrangedSubview(brightnessSlider)
        addSubview(brightnessSlider)
        
        brightnessSlider.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        brightnessSlider.value = 1
        brightnessSlider.maximumValue = 1
        brightnessSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        brightnessSlider.isHidden = true
        gradientView.isHidden = true
    }
    
    private func addTapHandlers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onGradientTouched(sender:)))
        gradientView.isUserInteractionEnabled = true
        gradientView.addGestureRecognizer(tap)
    }
    
    private func onViewModelChanged() {
        if viewModel.color != nil {
            switchControl.setOn(true, animated: true)
            switchChanged()
        }
        if colorValue == viewModel.color {
            return
        }
        if viewModel.color == nil {
            return
        }
        var hVal: CGFloat = 0
        var sVal: CGFloat = 0
        var bVal: CGFloat = 0
        var aVal: CGFloat = 0
        
        if viewModel.color!.getHue(&hVal, saturation: &sVal, brightness: &bVal, alpha: &aVal) {
            brightnessSlider.value = Float(bVal)
        }
    }
    
    @objc private func onGradientTouched(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: gradientView)
        viewModel.onColorChanged(gradientView.colorOfPoint(point: touchPoint))
        
    }
    
    @objc private func sliderValueChanged() {
        if brightnessLayer == nil {
            brightnessLayer = CALayer()
            brightnessLayer.frame = gradientView.bounds
            brightnessLayer.backgroundColor = UIColor.black.cgColor
            brightnessLayer.opacity = 0.0
            gradientView.layer.addSublayer(brightnessLayer)
        }
        
        brightnessLayer.opacity = 1 - brightnessSlider.value
    }
}
// swiftlint:enable trailing_whitespace
