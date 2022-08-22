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
    }


}

