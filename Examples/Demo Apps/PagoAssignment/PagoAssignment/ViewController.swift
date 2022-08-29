//
//  ViewController.swift
//  PagoAssignment
//
//  Created by Claudiu Miron on 22.08.2022.
//

import PagoUIKit
import UIKit

class ViewController: UIViewController {
    
    private let textView = DetailedTextView()

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
        
        textView.primaryFooterText = "Primary footer here"
        textView.primaryFooterFont = UIFont.systemFont(ofSize: 11,
                                                       weight: UIFont.Weight.heavy)
        textView.primaryFooterTextColor = UIColor.orange
        
        textView.secondaryFooterText = """
            A multiline secondary footer here to see
            if everything is alright UI-wise
        """
        textView.secondaryFooterFont = UIFont.systemFont(ofSize: 11,
                                                         weight: UIFont.Weight.heavy)
        textView.secondaryFooterTextColor = UIColor.gray
        
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

extension UIViewController: DetailedTextViewDelegate {
    public func detailedTextViewDidEndEditing(_ textView: DetailedTextView) {
        debugPrint("Editing stopped and text view reads: \(textView.text)")
    }
    
    public func detailedTextViewDidChange(_ textView: DetailedTextView) {
        debugPrint("Text view did change to: \(textView.text)")
    }
}
