//
//  ViewController.swift
//  PagoAssignment
//
//  Created by Claudiu Miron on 22.08.2022.
//

import PagoUIKit
import UIKit

class ViewController: UIViewController {
    
    private let textView = ImprovedTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -20).isActive = true
        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                           constant: 0).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        textView.font = UIFont.systemFont(ofSize: 17,
                                          weight: UIFont.Weight.heavy)
        textView.placeholder = "Write something…"
        textView.placeholderColor = UIColor.systemPink
        textView.text = "An ugly looking text view."
        textView.textColor = UIColor.blue
        
        textView.borderColor = UIColor.green
        textView.borderWidth = 5
        textView.cornerRadius = 30
        
        textView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController: ImprovedTextViewDelegate {
    public func improvedTextViewDidEndEditing(_ textView: ImprovedTextView) {
        debugPrint("Editing stopped and text view reads: \(textView.text)")
    }
    
    public func improvedTextViewDidChange(_ textView: ImprovedTextView) {
        debugPrint("Text view did change to: \(textView.text)")
    }
}
