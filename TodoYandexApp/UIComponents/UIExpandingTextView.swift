//
//  UIExpandingTextView.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 20.06.23.
//

import UIKit

///Has placeholder and autoexpanding features
open class UIExpandingTextView: UITextView, UITextViewDelegate {
    private var isEditing = false
    private var isEdited = false
    private var textDidChangeHandlers = [UUID: (UITextView) -> Void]()
    
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
    
    public override init(frame: CGRect = CGRect(), textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public convenience init() {
        self.init(frame: CGRect(), textContainer: nil)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        isEditing = true
        removePlaceholder()
        isEdited = true
        textViewDidChange(self)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        for handler in textDidChangeHandlers.values {
            handler(textView)
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        isEditing = false
        updatePlaceholder()
    }
    
    public func addTextDidChangeHandler(_ handler: @escaping (UITextView) -> Void) -> UUID {
        let id = UUID()
        textDidChangeHandlers[id] = handler
        
        return id
    }
    
    public func removeTextDidChangeHandler(withId id: UUID) {
        textDidChangeHandlers.removeValue(forKey: id)
    }
    
    private func updatePlaceholder() {
        if text.isEmpty || !isEdited {
            isEdited = false
            text = placeholder
            textColor = placeholderColor
        }
    }
    
    private func removePlaceholder() {
        if !isEdited {
            textColor = defaultTextColor
            text = ""
        }
    }
    
    private func setup() {
        delegate = self
        isScrollEnabled = false
        updatePlaceholder()
    }
}
