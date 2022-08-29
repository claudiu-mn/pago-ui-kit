//
//  ExplanatoryTextView.swift
//  
//
//  Created by Claudiu Miron on 28.08.2022.
//

import UIKit

@objc protocol ExplanatoryTextViewDelegate {
    @objc optional func explanatoryTextViewDidChange(_ textView: ExplanatoryTextView)
    @objc optional func explanatoryTextViewDidEndEditing(_ textView: ExplanatoryTextView)
}

/// A text view that can display a placeholder.
class ExplanatoryTextView: UIView {
    private weak var textView: UITextView!
    private weak var placeholderView: UITextView!
    
    public weak var delegate: ExplanatoryTextViewDelegate?
    
    public var placeholder: String = "" {
        didSet {
            placeholderView.text = placeholder
            updatePlaceholderVisibility()
        }
    }
    
    public var placeholderColor: UIColor? {
        get { return placeholderView.textColor }
        set { placeholderView.textColor = newValue }
    }
    
    public var text: String {
        get { return textView.text }
        set {
            textView.text = newValue
            updatePlaceholderVisibility()
        }
    }
    
    public var font: UIFont? {
        get { return textView.font }
        set {
            textView.font = newValue
            placeholderView.font = newValue
        }
    }
    
    public var textColor: UIColor? {
        get { return textView.textColor }
        set { textView.textColor = newValue }
    }
    
    public var textContainerInset: UIEdgeInsets {
        get { return textView.textContainerInset }
        set {
            textView.textContainerInset = newValue
            placeholderView.textContainerInset = newValue
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // TODO: Check RTL writing direction and implement if necessary
    private func commonInit() {
        let textView = UITextView()
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        textView.stick(toTop: 0,
                       toLeading: 0,
                       toBottom: 0,
                       toTrailing: 0,
                       of: self)
        self.textView = textView
        
        // TODO: No scrolling for placeholder. What if it has really long text?
        // TODO: Check for performance problems. Maybe substitute with UILabel?
        let placeholderView = UITextView()
        placeholderView.isEditable = false
        placeholderView.isUserInteractionEnabled = false
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderView)
        placeholderView.stick(toTop: 0,
                              toLeading: 0,
                              toBottom: 0,
                              toTrailing: 0,
                              of: self)
        placeholderView.textColor = UIColor.gray
        placeholderView.backgroundColor = UIColor.clear
        self.placeholderView = placeholderView
    }
    
    private func updatePlaceholderVisibility() {
        placeholderView.alpha = textView.text.isEmpty ? 1 : 0
    }
}

extension ExplanatoryTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
        delegate?.explanatoryTextViewDidChange?(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.explanatoryTextViewDidEndEditing?(self)
    }
}
