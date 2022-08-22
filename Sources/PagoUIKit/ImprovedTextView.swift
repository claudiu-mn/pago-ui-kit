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
        didSet {
            updateValidation()
        }
    }
    
    private let textView = UIKit.UITextView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        textView.delegate = self
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        
        let margin = 10.0
        
        textView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                          constant: margin).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                           constant: -margin).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor,
                                      constant: margin).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                         constant: -margin).isActive = true
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        
        updateValidation()
    }
    
    private func updateValidation() {
        if let errorText = validationErrorText {
            layer.borderColor = UIColor(rgb: 0xFF5151).cgColor
            return
        }
        
        layer.borderColor = UIColor(rgb: 0xEFF2F7).cgColor
    }
}

extension ImprovedTextView : UITextViewDelegate {
    
}
