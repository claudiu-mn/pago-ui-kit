//
//  ImprovedTextView.swift
//  
//
//  Created by Claudiu Miron on 22.08.2022.
//

import UIKit

public class ImprovedTextView : UIView {
    public var placeholder: String?
    
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
    
    public var mainFont: UIFont? {
        set { textView.font = newValue }
        get { return textView.font }
    }
    
    public var mainTextColor: UIColor? {
        set { textView.textColor = newValue }
        get { return textView.textColor }
    }
    
    private weak var textView: UITextView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let textView = UITextView()
        
        textView.delegate = self
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        textView.textContainerInset = UIEdgeInsets(top: 20,
                                                   left: 20,
                                                   bottom: 20,
                                                   right: 20)
        
        self.textView = textView
        
        mainFont = UIFont.systemFont(ofSize: 17)
        mainTextColor = UIColor.darkText
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

extension ImprovedTextView : UITextViewDelegate {
    
}
