//
//  PagoTextView.swift
//  
//
//  Created by Claudiu Miron on 01.09.2022.
//

import UIKit

@objc public protocol PagoTextViewDelegate {
    @objc optional func errorText(in textView: PagoTextView) -> String?
    
    /// Returning an empty string will make the text view display the default character count.
    @objc optional func characterCountText(for characterCount: UInt,
                                           in textView: PagoTextView) -> String
}

public class PagoTextView: UIView {
    public weak var delegate: PagoTextViewDelegate? {
        didSet {
            updateCharacterCount()
            updateErrorLabel()
            updateBorder()
        }
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
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
        stackView.axis = .vertical
        stackView.spacing = 5
        addSubview(stackView)
        stackView.stick(to: self,
                        atTop: 0,
                        atLeading: 0,
                        atBottom: 0,
                        atTrailing: 0)
        
        let textView = ExplanatoryTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textView)
        self.textView = textView
        
        textViewBorderWidth = 1
        textViewCornerRadius = 10
        
        textView.textContainerInset = UIEdgeInsets(top: 20,
                                                   left: 15,
                                                   bottom: 20,
                                                   right: 15)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textViewDidChange(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: textView)
        
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(errorLabel)
        self.errorLabel = errorLabel
        
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .unnatural
        errorTextColor = UIColor.systemRed
        
        updateErrorLabel()
        
        let countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(countLabel)
        self.characterCountLabel = countLabel
        
        countLabel.numberOfLines = 0
        countLabel.textAlignment = .unnatural
        characterCountColor = UIColor.secondaryLabel
        
        updateCharacterCount()
        
        updateBorder() // TODO: If moved above erorr label init, will crash
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification,
                                                  object: textView)
    }
    
    public private(set) weak var textView: ExplanatoryTextView!
    
    @objc private func textViewDidChange(_ notification: Notification) {
        trimExcessTextIfNecessary()
        
        updateCharacterCount()
        
        updateErrorLabel()
        updateBorder()
    }
    
    private func trimExcessTextIfNecessary() {
        // TODO: Investigate when text view is full (so, must have char limit)
        //       and you write 3 dots. I think the last two characters are replaced
        //       by an ellipsis (1 grapheme made from 2 units?)
        if textView.text.count > characterCountLimit && characterCountLimit != 0 {
            let oldText = textView.text!
            let lastIndex = oldText.index(oldText.startIndex,
                                          offsetBy: Int(characterCountLimit))
            let newText = oldText[..<lastIndex]
            textView.text = String(newText)
        }
    }
    
    // MARK: - Border
    
    public var textViewBorderWidth: CGFloat {
        get { return textView.layer.borderWidth }
        set { textView.layer.borderWidth = newValue }
    }
    
    public var textViewCornerRadius: CGFloat {
        get { return textView.layer.cornerRadius }
        set { textView.layer.cornerRadius = newValue }
    }
    
    private var borderColors: Dictionary<State, UIColor> = [
        .valid: UIColor.systemGray,
        .invalid: UIColor.systemRed
    ]
    
    public enum State {
        case valid, invalid
    }
    
    public func setTextViewBorderColor(_ color: UIColor, for state: State) {
        borderColors[state] = color
        updateBorder()
    }
    
    public func getTextViewBorderColor(for state: State) -> UIColor {
        return borderColors[state]!
    }
    
    private func updateBorder() {
        var color = getTextViewBorderColor(for: .valid)
        
        if let text = errorLabel.text {
            if !text.isEmpty {
                color = getTextViewBorderColor(for: .invalid)
            }
        }
        
        textView.layer.borderColor = color.cgColor
    }
    
    // MARK: - Error label
    
    private weak var errorLabel: UILabel!
    
    public var errorFont: UIFont! {
        get { return errorLabel.font }
        set { errorLabel.font = newValue }
    }
    
    public var errorTextColor: UIColor! {
        get { return errorLabel.textColor }
        set { errorLabel.textColor = newValue }
    }
    
    private func updateErrorLabel() {
        let errorText = self.delegate?.errorText?(in: self)
        self.updateErrorLabel(with: errorText)
    }
    
    private func updateErrorLabel(with errorText: String?) {
        errorLabel.text = errorText
    }
    
    // MARK: - Character count
    
    private weak var characterCountLabel: UILabel!
    
    /// Setting this to 0 will hide the character count.
    ///
    /// The default format of the label is 't / m', where t is the number of typed characters and m is the value of this property
    /// The character count label can be customized by implementing characterCountText(for:in:) in the delegate.
    public var characterCountLimit: UInt = 300 {
        didSet {
            trimExcessTextIfNecessary()
            updateCharacterCount()
        }
    }
    
    public var characterCountColor: UIColor! {
        get { return characterCountLabel.textColor }
        set { characterCountLabel.textColor = newValue }
    }
    
    public var characterCountFont: UIFont! {
        get { return characterCountLabel.font }
        set { characterCountLabel.font = newValue }
    }
    
    private func updateCharacterCount() {
        let count = UInt(textView.text.count)
        let countString = self.delegate?.characterCountText?(for: count, in: self)
        self.updateCharacterCountLabel(with: countString)
    }
    
    private func updateCharacterCountLabel(with customString: String?) {
        if characterCountLimit == 0 {
            characterCountLabel.text = nil
        } else {
            var text = "\(textView.text.count) / \(characterCountLimit)"
            if customString != nil && !customString!.isEmpty {
                text = customString!
            }
            characterCountLabel.text = text
        }
    }
}
