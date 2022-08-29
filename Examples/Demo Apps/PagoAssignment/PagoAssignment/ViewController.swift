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
    private weak var textView: ValidatingTextView!
    
    private weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacing: CGFloat = 40
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = spacing
        view.addSubview(stackView)
        stackView.stick(safely: true,
                        toTop: spacing,
                        toLeading: spacing,
                        toTrailing: -spacing,
                        of: view)
        bottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                             constant: -spacing)
        bottomConstraint.isActive = true
        self.stackView = stackView
        
        let textView = ValidatingTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textView)
        
        textView.text = "Why so blue, crew?"
        textView.textColor = UIColor.systemBlue
        
        textView.placeholder = "Write something in this blue text view…"
        textView.placeholderColor = UIColor.systemCyan
        
        textView.characterCountPrefix = "You have "
        textView.characterCountLimitHint = 20
        textView.characterCountSuffix = " characters."
        
        textView.primaryFont = UIFont.systemFont(ofSize: 25)
        textView.secondaryFont = UIFont.systemFont(ofSize: 15)
        
        textView.setDynamicColor(UIColor.systemOrange, for: .invalid)
        textView.setDynamicColor(UIColor.systemTeal, for: .valid)
        textView.characterCountColor = UIColor.systemMint
        
        textView.delegate = self
        
        self.textView = textView
        
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Toggle error state", for: UIControl.State.normal)
        button.backgroundColor = UIColor(rgb: 0xEFF2F7)
        button.layer.cornerRadius = 10
        button.addTarget(self,
                         action: #selector(onButtonTap(sender:)),
                         for: .touchUpInside)
        stackView.addArrangedSubview(button)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(ViewController.dismissKeyboard))
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
    
    @objc private func onButtonTap(sender: UIButton) {
        if textView.errorText != nil {
            textView.errorText = nil
        } else {
            textView.errorText = "Some generic error to test things out!"
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // Shamelessly stolen from https://gist.github.com/nekonora/21fd87b1d4192b5d102200199206baee
    @objc func keyboardWillShow(notification: NSNotification) {
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
    
    @objc func keyboardWillHide(notification: NSNotification) {
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

extension UIViewController: ValidatingTextViewDelegate {
    public func validatingTextViewDidEndEditing(_ textView: ValidatingTextView) {
        debugPrint("Editing stopped and text view reads: \(textView.text)")
    }
    
    public func validatingTextViewDidChange(_ textView: ValidatingTextView) {
        debugPrint("Text view did change to: \(textView.text)")
    }
}
