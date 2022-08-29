//
//  ValidatingTextView.swift
//  
//
//  Created by Claudiu Miron on 29.08.2022.
//

import UIKit


@objc public protocol ValidatingTextViewDelegate {
    @objc optional func validatingTextViewDidChange(_ textView: ValidatingTextView)
    @objc optional func validatingTextViewDidEndEditing(_ textView: ValidatingTextView)
}

public class ValidatingTextView: UIView {
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
        let textView = DetailedTextView()
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        textView.stick(toTop: 0,
                       toLeading: 0,
                       toBottom: 0,
                       toTrailing: 0,
                       of: self)
        self.textView = textView
        
        placeholder = "Input text here…"
        
        textView.primaryFooterFont = secondaryFont
        textView.secondaryFooterFont = secondaryFont
        
        textView.primaryFooterTextColor = dynamicColor[.invalid]!
        
        updateBorderColor()
        updateCharacterCountLabel()
    }
    
    // MARK: - Appearance
    
    public enum State {
        case valid, invalid
    }
    
    // TODO: Weird name which makes me think it's a code smell
    private var dynamicColor: Dictionary<State, UIColor> = [
        .valid: UIColor.lightGray,
        .invalid: UIColor.systemRed
    ]
    
    public func getDynamicColor(for state: State) -> UIColor {
        return dynamicColor[state]!
    }
    
    public func setDynamicColor(_ color: UIColor, for state: State) {
        dynamicColor[state] = color
        if state == .invalid { textView.primaryFooterTextColor = color }
        updateBorderColor()
    }
    
    private func updateBorderColor() {
        let hasError = errorText == nil ? false : errorText!.isEmpty ? false : true
        textView.borderColor = hasError ? dynamicColor[.invalid] : dynamicColor[.valid]
    }
    
    // MARK: - Text view

    public weak var delegate: ValidatingTextViewDelegate?
    
    private weak var textView: DetailedTextView!
    
    public var placeholder: String? {
        get { return textView.placeholder }
        set { textView.placeholder = newValue }
    }
    
    public var placeholderColor: UIColor? {
        get { return textView.placeholderColor }
        set { textView.placeholderColor = newValue }
    }
    
    public var text: String {
        get { return textView.text }
        set { textView.text = newValue }
    }
    
    public var primaryFont: UIFont? {
        get { return textView.font }
        set { textView.font = newValue }
    }
    
    public var textColor: UIColor? {
        get { return textView.textColor }
        set { textView.textColor = newValue }
    }
    
    // MARK: - Footers
    
    public var secondaryFont: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote) {
        didSet {
            textView.primaryFooterFont = secondaryFont
            textView.secondaryFooterFont = secondaryFont
        }
    }
    
    // MARK: Errors
    
    public var errorText: String? {
        didSet {
            // TODO: What if we start with an invalid state?
            textView.primaryFooterText = errorText
            updateBorderColor()
        }
    }
    
    // MARK: Character count
    
    public var hideCharacterCount: Bool = false {
        didSet { updateCharacterCountLabel() }
    }
    
    public var characterCountLimitHint: Int = 300 {
        didSet { updateCharacterCountLabel() }
    }
    
    public var characterCountPrefix: String? {
        didSet { updateCharacterCountLabel() }
    }
    
    public var characterCountSuffix: String? {
        didSet { updateCharacterCountLabel() }
    }
    
    public var characterCountColor: UIColor {
        get { return textView.secondaryFooterTextColor }
        set { textView.secondaryFooterTextColor = newValue }
    }
    
    private func updateCharacterCountLabel() {
        var footerText: String?
        
        // TODO: Do prefixes and suffixes swap roles in RTL languages?
        if !hideCharacterCount {
            var text = characterCountPrefix ?? ""
            text += "\(textView.text.count) / \(characterCountLimitHint)"
            text += characterCountSuffix ?? ""
            footerText = text
        }
        
        textView.secondaryFooterText = footerText
    }
}

extension ValidatingTextView: DetailedTextViewDelegate {
    func detailedTextViewDidChange(_ textView: DetailedTextView) {
        updateCharacterCountLabel()
        delegate?.validatingTextViewDidChange?(self)
    }
    
    func detailedTextViewDidEndEditing(_ textView: DetailedTextView) {
        delegate?.validatingTextViewDidEndEditing?(self)
    }
}
