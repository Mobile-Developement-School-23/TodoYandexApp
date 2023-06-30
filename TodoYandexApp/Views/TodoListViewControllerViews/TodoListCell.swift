//
//  TodoListCell.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 26.06.23.
//

import UIKit

class TodoListCell: UITableViewCell {
    private var stackView = UIStackView()
    private lazy var textStackView = UIStackView()
    let checkbox = CircleCheckboxView()
    let label = UILabel()
    let date = UILabel()
    
    var todoItem: TodoItem?
    var onTodoChanged: ((TodoItem) -> Void)?
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        contentView.layoutMargins = LayoutValues.padding
        contentView.layoutMarginsDidChange()
        separatorInset = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)
        addStackView()
    }
    
    func rerenderWith(item: TodoItem) {
        todoItem = item
        
        //Set label value
        if !item.done {
            let prefix = item.importance == .important ? AssetsImages.exclamationImage : item.importance == .low ? AssetsImages.arrowDownImage : nil
            if prefix != nil {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = prefix!
                let string = NSMutableAttributedString()
                string.append(NSAttributedString(attachment: imageAttachment))
                string.append(NSAttributedString(string: item.text))
                label.attributedText = string
            } else {
                label.attributedText = NSAttributedString(string: item.text)
            }
            if item.color != nil {
                label.textColor = UIColor(hexString: item.color!)
            } else {
                label.textColor = AssetsColors.labelPrimary
            }
        } else {
            let attributeString = NSMutableAttributedString(string: item.text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            label.attributedText = attributeString
            label.textColor = AssetsColors.labelTertiary
        }
        label.font = AssetsFonts.body
        
        checkbox.setIsOn(item.done)
        checkbox.setIsError(todoItem?.importance == .important)
        
        if item.deadline != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = AssetsImages.caldendarImage
            let string = NSMutableAttributedString()
            string.append(NSAttributedString(attachment: imageAttachment))
            string.append(NSAttributedString(string: dateFormatter.string(from: item.deadline!)))
            date.attributedText = string
            date.isHidden = false
        } else {
            date.isHidden = true
        }
    }
    
    func onCheckboxValueChanged(_ isOn: Bool) {
        if todoItem == nil {
            return
        }
        
        todoItem = TodoItem(id: todoItem!.id, text: todoItem!.text, importance: todoItem!.importance, deadline: todoItem!.deadline, done: isOn, createdAt: todoItem!.createdAt, changedAt: todoItem!.changedAt, color: todoItem!.color)
        (onTodoChanged ?? {_ in })(todoItem!)
    }
    
    private func addStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fill
        addCheckboxView()
        configureTextStackView()
    }
    
    private func addCheckboxView() {
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setIsOn(todoItem?.done ?? false)
        checkbox.defaultImage = AssetsImages.defaultCheckmarkImage
        checkbox.errorImage = AssetsImages.errorCheckmarkImage
        checkbox.checkedImage = AssetsImages.checkedImage
        checkbox.delegate = onCheckboxValueChanged(_:)
        stackView.addArrangedSubview(checkbox)
        stackView.addSubview(checkbox)
        checkbox.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        checkbox.widthAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    private func configureTextStackView() {
        textStackView.translatesAutoresizingMaskIntoConstraints = true
        textStackView.autoresizingMask = [.flexibleWidth]
        textStackView.axis = .vertical
        stackView.addArrangedSubview(textStackView)
        stackView.addSubview(textStackView)
        textStackView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        textStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        textStackView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 15).isActive = true
        addLabel()
        addDate()
    }
    
    private func addLabel() {
        textStackView.addArrangedSubview(label)
        textStackView.addSubview(label)
        label.numberOfLines = 3
        label.font = AssetsFonts.body
        label.textColor = AssetsColors.labelPrimary
    }
    
    private func addDate() {
        textStackView.addArrangedSubview(date)
        textStackView.addSubview(date)
        date.isHidden = true
        date.textColor = AssetsColors.labelTertiary
        date.font = AssetsFonts.subhead
    }
}
