//
//  UIExpandingTextView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 20.06.23.
//

import UIKit

public class UIExpandingTextView: UITextView, UITextViewDelegate {
    private var isEditing = false
    
    ///Placeholder text color
    public var placeholderColor = UIColor.lightGray {
        didSet {
            if !isEditing {
                updatePlaceholder()
            }
        }
    }
    
    ///Aka textColor
    public var defaultTextColor = UIColor.black {
        didSet {
            if !isEditing {
                updatePlaceholder()
            }
        }
    }
    
    ///The text that the text view displays when it is empty.
    public var placeholder = "Placeholder" {
        didSet {
            if !isEditing {
                updatePlaceholder()
            }
        }
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init() {
        self.init(frame: CGRect(), textContainer: nil)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        isEditing = true
        removePlaceholder()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        isEditing = false
        updatePlaceholder()
    }
    
    private func updatePlaceholder() {
        if text.isEmpty {
            text = placeholder
            textColor = placeholderColor
        }
    }
    
    private func removePlaceholder() {
        textColor = defaultTextColor
        text = ""
    }
    
    private func setup() {
        delegate = self
        isScrollEnabled = false
        updatePlaceholder()
    }
}
