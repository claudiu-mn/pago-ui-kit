//
//  UIView+Constraints.swift
//  
//
//  Created by Claudiu Miron on 28.08.2022.
//

import UIKit

extension UIView {
    func fill(_ otherView: UIView,
              with insets: UIEdgeInsets = UIEdgeInsets.zero) {
        leadingAnchor.constraint(equalTo: otherView.leadingAnchor,
                                 constant: insets.left).isActive = true
        trailingAnchor.constraint(equalTo: otherView.trailingAnchor,
                                  constant: -insets.right).isActive = true
        topAnchor.constraint(equalTo: otherView.topAnchor,
                             constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: otherView.bottomAnchor,
                                constant: -insets.bottom).isActive = true
    }
}
