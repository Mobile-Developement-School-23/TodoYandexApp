//
//  TodoDetailsStackView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 21.06.23.
//

import UIKit

class TodoDetailsStackView: UIStackView, DeactivatedView {
    private var fieldsStackView: VerticalStackLayoutView!
    private var calendarSwitch: TodoDetailsCalendarSwitch!
    private var textView: TodoDetailsTextInputView!
    private var importance: TodoDetailsSegmentedControlWithLabel!
    private let calendarView = UICalendarView()
    private weak var viewModel: TodoDetailsViewModel?
    private var dateSelection: UICalendarSelectionSingleDate!
    private var isCalendarViewShowed = false
    private var deleteButton: TodoDetailsDeleteButton!
    private var colorLabel: UILabel!
    
    init(frame: CGRect = CGRect(), viewModel: TodoDetailsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        axis = NSLayoutConstraint.Axis.vertical
        distribution = UIStackView.Distribution.equalSpacing
        alignment = UIStackView.Alignment.center
        spacing = LayoutValues.spacing
        translatesAutoresizingMaskIntoConstraints = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)

        configureSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateViewWithAnchors(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, width: NSLayoutDimension?, height: NSLayoutDimension? = nil, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        
        guard let top = top, let bot = bottom, let leading = leading, let trailing = trailing, let width = width else {
            return
        }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: top),
            leadingAnchor.constraint(equalTo: leading),
            trailingAnchor.constraint(equalTo: trailing),
            bottomAnchor.constraint(equalTo: bot),
            widthAnchor.constraint(equalTo: width)
        ])
    }
    
    private func configureSubviews() {
        addColorLabel()
        
        configureTextView()
        
        configureFieldsStackView()
        
        configureDeleteButton()
        
        setupCalendarDelegates()
        
        viewModel?.addDelegate(onViewModelChanged)
    }
    
    private func configureTextView() {
        textView = TodoDetailsTextInputView()
        _ = textView.addTextDidChangeHandler(textValueChanged(_:))
        
        addSubview(textView)
        addArrangedSubview(textView)
        textView.activateViewWithAnchors(width: widthAnchor)
    }
    
    private func configureFieldsStackView() {
        guard let viewModel = viewModel else {
            return
        }
        importance = TodoDetailsSegmentedControlWithLabel(viewModel: viewModel)
        calendarSwitch = TodoDetailsCalendarSwitch(viewModel: viewModel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(switchCalendarShowStatus(sender:)))
        calendarSwitch.addGestureRecognizer(tap)
        calendarSwitch.switchDelegate = self
        fieldsStackView = VerticalStackLayoutView()
            .setPadding(LayoutValues.padding)
            .setSeparatorColor(AssetsColors.supportSeparator)
            .setSpacing(LayoutValues.spacing)
            .withBackgroundColor(AssetsColors.backSecondary)
            .addSeparatedSubview(importance)
            .addSeparatedSubview(TodoDetailsSwitchingColorPicker(viewModel: viewModel))
            .addSeparatedSubview(calendarSwitch)
            .setRadius(LayoutValues.cornerRadius)
        
        addArrangedSubview(fieldsStackView)
        addSubview(fieldsStackView)
        
        fieldsStackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func configureDeleteButton() {
        deleteButton = TodoDetailsDeleteButton()
        deleteButton.addTarget(self, action: #selector(onDeleteButtonClicked), for: .touchDown)
        addArrangedSubview(deleteButton)
        addSubview(deleteButton)
        deleteButton.activateViewWithAnchors(width: widthAnchor)
    }
    
    @objc private func switchCalendarShowStatus(sender: UITapGestureRecognizer) {
        guard viewModel?.deadline != nil else {
            return
        }
        isCalendarViewShowed = !isCalendarViewShowed
        if isCalendarViewShowed {
            _ = fieldsStackView.addSeparatedSubview(calendarView, animated: true)
        } else {
            _ = fieldsStackView.removeSeparatedSubview(calendarView, animated: true)
        }
    }
    
    @objc private func onDeleteButtonClicked() {
        viewModel?.deleteTodoItem()
    }
    
    
    @objc private func keyboardWillAppear() {
        UIView.animate(withDuration: 0.2, animations: {
            self.fieldsStackView.isHidden = true
            self.calendarSwitch.isHidden = true
            self.importance.isHidden = true
            self.calendarView.isHidden = true
            self.deleteButton.isHidden = true
            self.colorLabel.isHidden = true
            self.fieldsStackView.alpha = 0
            self.calendarSwitch.alpha = 0
            self.importance.alpha = 0
            self.calendarView.alpha = 0
            self.deleteButton.alpha = 0
            self.colorLabel.alpha = 0
        })
    }

    @objc private func keyboardWillDisappear() {
        UIView.animate(withDuration: 0.2, animations: {
            self.fieldsStackView.isHidden = false
            self.calendarSwitch.isHidden = false
            self.importance.isHidden = false
            self.calendarView.isHidden = false
            self.deleteButton.isHidden = false
            self.colorLabel.isHidden = false
            self.fieldsStackView.alpha = 1
            self.calendarSwitch.alpha = 1
            self.importance.alpha = 1
            self.calendarView.alpha = 1
            self.deleteButton.alpha = 1
            self.colorLabel.alpha = 1
        })
    }
    
    private func addColorLabel() {
        colorLabel = UILabel()
        addArrangedSubview(colorLabel)
        addSubview(colorLabel)
        
        guard let viewModel = viewModel else {
            return
        }
        colorLabel.text = "Цвет: " + (viewModel.color?.htmlRGBColor ?? AssetsColors.labelPrimary.htmlRGBColor)
        colorLabel.textColor = viewModel.color ?? AssetsColors.labelPrimary
        colorLabel.font = AssetsFonts.body
        colorLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
    
    private func setupCalendarDelegates() {
        dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
    }
    
    private func textValueChanged(_ view: UITextView) {
        viewModel?.onTextChanged(view.text)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TodoDetailsStackView: UICalendarSelectionSingleDateDelegate, TodoDetailsCalendarSwitchDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents else {
            return
        }
        
        viewModel?.onDateChanged(dateComponents.date)
    }
    
    func onValueChanged(value: Bool) {
        guard let viewModel = viewModel else {
            return
        }
        if value {
            if !isCalendarViewShowed {
                _ = fieldsStackView.addSeparatedSubview(calendarView, animated: true)
                isCalendarViewShowed = true
            }
            if viewModel.deadline == nil {
                viewModel.onDateChanged(Date.now.addingTimeInterval(86400))
            }
        } else {
            if isCalendarViewShowed {
                _ = fieldsStackView.removeSeparatedSubview(calendarView, animated: true)
                isCalendarViewShowed = false
            }
            viewModel.onDateChanged(nil)
        }
    }
}

extension TodoDetailsStackView {
    func onViewModelChanged() {
        guard let viewModel = viewModel else {
            return
        }
        if textView.text != viewModel.text && (viewModel.text != "" || textView.isEdited) {
            textView.removePlaceholder()
            if viewModel.text != "" {
                textView.isEdited = true
            }
            textView.text = viewModel.text
        }
        if viewModel.importance == .low {
            importance.setSelectedKey(0)
        } else if viewModel.importance == .important {
            importance.setSelectedKey(2)
        } else {
            importance.setSelectedKey(1)
        }
        if dateSelection.selectedDate?.date != viewModel.deadline && viewModel.deadline != nil {
            dateSelection.setSelected(Calendar.current.dateComponents([.day, .month, .year], from: viewModel.deadline!), animated: true)
        }
        if viewModel.deadline != nil {
            calendarSwitch.setDateValueText()
            calendarSwitch.setValue(true)
        }
        deleteButton.isEnabled = viewModel.isSaved
        
        let color = viewModel.color ?? AssetsColors.labelPrimary
        if viewModel.text != "" && textView.defaultTextColor != color {
            let font = textView.font
            let attrText = NSAttributedString(string: viewModel.text)
            textView.attributedText = attrText
            textView.font = font
            textView.defaultTextColor = color
            textView.isEdited = true
            textView.text = viewModel.text
        }
        
        colorLabel.text = "Цвет: " + (color.htmlRGBColor)
        colorLabel.textColor = viewModel.color ?? AssetsColors.labelPrimary
        
        if (colorLabel.isHidden && viewModel.color != nil) || (viewModel.color == nil && !colorLabel.isHidden) {
            UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.colorLabel.isHidden = self.viewModel?.color == nil
                self.colorLabel.alpha = self.viewModel?.color == nil ? 0 : 1
            }, completion: nil)
        }
    }
}
