//
//  ImprovedTextView.swift
//  
//
//  Created by Claudiu Miron on 22.08.2022.
//

import UIKit

@objc public protocol ImprovedTextViewDelegate {
    @objc optional func improvedTextViewDidChange(_ textView: ImprovedTextView)
    @objc optional func improvedTextViewDidEndEditing(_ textView: ImprovedTextView)
}

public class ImprovedTextView : UIView {
    public weak var delegate: ImprovedTextViewDelegate?
    
    public var validationErrorText: String? {
        didSet { updateValidation() }
    }
    
    public var borderColor: UIColor? {
        set { textView.layer.borderColor = newValue?.cgColor }
        get {
            guard let cgColor = textView.layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
    }
    
    public var borderWidth: CGFloat {
        set { textView.layer.borderWidth = newValue }
        get { return textView.layer.borderWidth }
    }
    
    public var cornerRadius: CGFloat {
        set { textView.layer.cornerRadius = newValue }
        get { return textView.layer.cornerRadius }
    }
    
    public var font: UIFont? {
        set { textView.font = newValue }
        get { return textView.font }
    }
    
    public var placeholder: String? {
        didSet { textView.placeholder = placeholder ?? "" }
    }
    
    public var placeholderColor: UIColor? {
        get { return textView.placeholderColor }
        set { textView.placeholderColor = newValue }
    }
    
    public var text: String {
        get { return textView.text }
        set { textView.text = newValue }
    }
    
    public var textColor: UIColor? {
        set { textView.textColor = newValue }
        get { return textView.textColor }
    }
    
    private weak var textView: ExplanatoryTextView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let textView = ExplanatoryTextView()
        
        textView.delegate = self
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        
        textView.fill(self)
        
        textView.textContainerInset = UIEdgeInsets(top: 20,
                                                   left: 17,
                                                   bottom: 20,
                                                   right: 17)
        
        self.textView = textView
        
        font = UIFont.systemFont(ofSize: 17)
        textColor = UIColor.darkText
        cornerRadius = 10
        borderWidth = 2
        updateValidation()
    }
    
    private func updateValidation() {
        if validationErrorText != nil {
            borderColor = UIColor(rgb: 0xFF5151)
        } else {
            borderColor = UIColor(rgb: 0xEFF2F7)
        }
    }
}

extension ImprovedTextView : ExplanatoryTextViewDelegate {
    func explanatoryTextViewDidChange(_ textView: ExplanatoryTextView) {
        delegate?.improvedTextViewDidChange?(self)
    }
    
    func explanatoryTextViewDidEndEditing(_ textView: ExplanatoryTextView) {
        delegate?.improvedTextViewDidEndEditing?(self)
    }
}
