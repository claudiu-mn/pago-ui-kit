//
//  ViewController.swift
//  PagoAssignment
//
//  Created by Claudiu Miron on 22.08.2022.
//

import PagoUIKit
import UIKit

class ViewController: UIViewController {
    private weak var stackView: UIStackView!
    
    private weak var textView: PagoTextView!
    
    private weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacing: CGFloat = 40
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = spacing
        view.addSubview(stackView)
        stackView.stick(to: view,
                        safely: true,
                        atTop: spacing,
                        atLeading: spacing,
                        atTrailing: -spacing)
        bottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                             constant: -spacing)
        bottomConstraint.isActive = true
        self.stackView = stackView
        
        let textView = PagoTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textView)
        textView.delegate = self
        self.textView = textView
        
        let characterCountLimit: UInt = 37
        
        // TODO: Awkward textView.textView syntax
        textView.textView.font = UIFont.systemFont(ofSize: 25)
        
//        textView.textView.text = "Delete this to reveal the placeholder"
        textView.textView.textColor = UIColor.systemBlue
        
        textView.textView.placeholder = """
        1. Write 'error' (case-insensitive) to trigger an invalid state
            
        2. Write more than \(characterCountLimit) chars

        3. Hire me…
        """
        textView.textView.placeholderColor = UIColor.systemCyan
        
        textView.textViewBorderWidth = 2
        textView.textViewCornerRadius = 20
        textView.setTextViewBorderColor(UIColor.systemTeal, for: .valid)
        textView.setTextViewBorderColor(UIColor.systemOrange, for: .invalid)

        textView.errorFont = UIFont.systemFont(ofSize: 15)
        textView.errorTextColor = UIColor.systemOrange
        
        textView.characterCountFont = UIFont.systemFont(ofSize: 15)
        textView.characterCountColor = UIColor.systemMint
        textView.characterCountLimit = characterCountLimit
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Useless button", for: .normal)
        button.backgroundColor = UIColor.systemGray5
        button.layer.cornerRadius = 10
        stackView.addArrangedSubview(button)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Shamelessly stolen from https://gist.github.com/nekonora/21fd87b1d4192b5d102200199206baee
    @objc private func keyboardWillShow(notification: NSNotification) {
        let keyboardAnimationDetail = notification.userInfo
        
        let animationCurve: Int = {
            if let keyboardAnimationCurve = keyboardAnimationDetail?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int {
                let curve: Int? = UIView.AnimationCurve(rawValue: keyboardAnimationCurve)?.rawValue
                return curve ?? 0
            } else {
                return 0
            }
        }()
        
        let duration: Double = {
            if let animationDuration = keyboardAnimationDetail?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Int {
                return Double(animationDuration)
            } else {
                return 0
            }
        }()
        
        let options = UIView.AnimationOptions(rawValue: ((UInt(animationCurve << 16))))
        
        var keyboardHeight = CGFloat(0.0)
        
        if let keyboardFrame: NSValue = keyboardAnimationDetail?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.bottomConstraint.constant = -keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let keyboardAnimationDetail = notification.userInfo
        
        let animationCurve: Int = {
            if let keyboardAnimationCurve = keyboardAnimationDetail?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int {
                let curve: Int? = UIView.AnimationCurve(rawValue: keyboardAnimationCurve)?.rawValue
                return curve ?? 0
            } else {
                return 0
            }
        }()
        
        let duration: Double = {
            if let animationDuration = keyboardAnimationDetail?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Int {
                return Double(animationDuration)
            } else {
                return 0
            }
        }()
        
        let options = UIView.AnimationOptions(rawValue: ((UInt(animationCurve << 16))))
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController: PagoTextViewDelegate {
    public func characterCountText(for characterCount: UInt,
                                   in textView: PagoTextView) -> String {
        return "\(characterCount) / \(textView.characterCountLimit) characters"
    }
    
    public func errorText(in textView: PagoTextView) -> String {
        // TODO: Here's that awkward textView.textView syntax again
        if textView.textView.text.lowercased().contains("error") {
            return """
            You've successfully mocked an invalid state.
            Here's a particularly long error text to test things out.
            """
        }
        
        return ""
    }
}
