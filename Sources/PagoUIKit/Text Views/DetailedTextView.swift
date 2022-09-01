//
//  DetailedTextView.swift
//  
//
//  Created by Claudiu Miron on 22.08.2022.
//

import UIKit

@objc protocol DetailedTextViewDelegate {
    @objc optional func detailedTextViewDidChange(_ textView: DetailedTextView)
    @objc optional func detailedTextViewDidEndEditing(_ textView: DetailedTextView)
}

/// A text view with a maximum of two footers (UILabels) underneath.
class DetailedTextView : UIView {
    public weak var delegate: DetailedTextViewDelegate?
    
    // MARK: - Border

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
    
    // MARK: - Text view
    
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
    
    // MARK: - Footers
    // TODO: Consider exposing the labels as read-only and delete rest of props
    //       And why just two? Maybe manage an array of UIViews?
    
    // MARK: Primary
    
    public var primaryFooterFont: UIFont {
        get { return primaryFooter.font }
        set { primaryFooter.font = newValue }
    }
    
    public var primaryFooterTextColor: UIColor {
        get { return primaryFooter.textColor }
        set { primaryFooter.textColor = newValue }
    }
    
    public var primaryFooterText: String? {
        get { return primaryFooter.text }
        set { primaryFooter.text = newValue }
    }
    
    private weak var primaryFooter: UILabel!
    
    // MARK: Secondary
    
    public var secondaryFooterFont: UIFont {
        get { return secondaryFooter.font }
        set { secondaryFooter.font = newValue }
    }
    
    public var secondaryFooterTextColor: UIColor {
        get { return secondaryFooter.textColor }
        set { secondaryFooter.textColor = newValue }
    }
    
    public var secondaryFooterText: String? {
        get { return secondaryFooter.text }
        set { secondaryFooter.text = newValue }
    }
    
    private weak var secondaryFooter: UILabel!
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 5
        addSubview(stackView)
        stackView.stick(toTop: 0,
                        toLeading: 0,
                        toBottom: 0,
                        toTrailing: 0,
                        of: self)
        
        let textView = ExplanatoryTextView()
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textView)
        textView.textContainerInset = UIEdgeInsets(top: 20,
                                                   left: 17,
                                                   bottom: 20,
                                                   right: 17)
        textView.layer.masksToBounds = true
        self.textView = textView
        
        font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textColor = UIColor.darkText
        cornerRadius = 10
        borderWidth = 2
        borderColor = UIColor.lightGray

        // TODO: Check RTL writing direction and implement if necessary
        let font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        
        primaryFooter = addFooterLabel(to: stackView)
        primaryFooterFont = font
        primaryFooterTextColor = UIColor.gray

        secondaryFooter = addFooterLabel(to: stackView)
        secondaryFooterFont = font
        secondaryFooterTextColor = UIColor.lightGray
    }
    
    private func addFooterLabel(to stackView: UIStackView) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.right
        stackView.addArrangedSubview(label)
        return label
    }
}

extension DetailedTextView : UITextViewDelegate {
    func explanatoryTextViewDidChange(_ textView: ExplanatoryTextView) {
        delegate?.detailedTextViewDidChange?(self)
    }
    
    func explanatoryTextViewDidEndEditing(_ textView: ExplanatoryTextView) {
        delegate?.detailedTextViewDidEndEditing?(self)
    }
}
