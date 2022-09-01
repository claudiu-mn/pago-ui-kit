//
//  ExplanatoryTextView.swift
//  
//
//  Created by Claudiu Miron on 31.08.2022.
//

import UIKit

// TODO: Consider making it IBDesignable
// TODO: Consider working with attributable text as well
/// A UITextView subclass that can display a placeholder
class ExplanatoryTextView: UITextView {
    // MARK: - Initialization
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // TODO: Check RTL writing direction and implement if necessary
    private func commonInit() {
        // TODO: No scrolling for placeholder. What if it has really long text?
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        let top = label.topAnchor.constraint(equalTo: frameLayoutGuide.topAnchor)
        top.isActive = true
        placeholderTop = top

        let leading = label.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor)
        leading.isActive = true
        placeholderLeading = leading
        
        let trailing = label.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor)
        trailing.isActive = true
        placeholderTrailing = trailing
        
        label.numberOfLines = 0

        label.textColor = UIColor.secondaryLabel
        label.textAlignment = textAlignment
        
        placeholderLabel = label
        
        updatePlaceholderMargins()
        updatePlaceholderVisibility()
        
        // TODO: I don't like this
        font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textViewDidChange(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
    }
    
    @objc private func textViewDidChange(_ notification: Notification) {
        updatePlaceholderVisibility()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification,
                                                  object: self)
    }
    
    // MARK: - Placeholder
    
    private weak var placeholderLabel: UILabel!

    private weak var placeholderTop: NSLayoutConstraint!
    private weak var placeholderLeading: NSLayoutConstraint!
    private weak var placeholderTrailing: NSLayoutConstraint!
    
    public var placeholder: String? {
        get { return placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }
    
    public var placeholderColor: UIColor! {
        get { return placeholderLabel.textColor }
        set { placeholderLabel.textColor = newValue }
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.alpha = text.isEmpty ? 1 : 0
    }
    
    // TODO: Does RTL change anything?
    private func updatePlaceholderMargins() {
        placeholderTop.constant = textContainerInset.top
        placeholderLeading.constant = textContainerInset.left + textContainer.lineFragmentPadding
        placeholderTrailing.constant = -(textContainerInset.right + textContainer.lineFragmentPadding)
    }
    
    // MARK: - UITextView
    
    public override var font: UIFont? {
        get { return super.font }
        set {
            super.font = newValue
            placeholderLabel.font = newValue
        }
    }
    
    public override var text: String! {
        get { return super.text }
        set {
            super.text = newValue
            updatePlaceholderVisibility()
        }
    }
    
    public override var textAlignment: NSTextAlignment {
        get { return super.textAlignment }
        set {
            super.textAlignment = newValue
            placeholderLabel.textAlignment = newValue
        }
    }
    
    public override var textContainerInset: UIEdgeInsets {
        get { return super.textContainerInset }
        set {
            super.textContainerInset = newValue
            updatePlaceholderMargins()
        }
    }
}
