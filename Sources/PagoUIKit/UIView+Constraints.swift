//
//  UIView+Constraints.swift
//  
//
//  Created by Claudiu Miron on 28.08.2022.
//

import UIKit

public extension UIView {
    // TODO: This method no longer makes me feel right
    /// No-op if toTop, toLeft, toBottom and toRight are nil
    func stick(safely: Bool = true,
               toTop: CGFloat? = nil,
               toLeading: CGFloat? = nil,
               toBottom: CGFloat? = nil,
               toTrailing: CGFloat? = nil,
               of otherView: UIView) {
        if toTop == nil && toLeading == nil && toBottom == nil && toTrailing == nil {
            return
        }
        
        if let top = toTop {
            let otherTop = safely ?
            otherView.safeAreaLayoutGuide.topAnchor : otherView.topAnchor
            topAnchor.constraint(equalTo: otherTop,
                                 constant: top).isActive = true
        }
        
        if let bottom = toBottom {
            let otherBottom = safely ?
            otherView.safeAreaLayoutGuide.bottomAnchor : otherView.bottomAnchor
            bottomAnchor.constraint(equalTo: otherBottom,
                                    constant: bottom).isActive = true
        }
        
        if let leading = toLeading {
            let otherLeading = safely ?
            otherView.safeAreaLayoutGuide.leadingAnchor : otherView.leadingAnchor
            leadingAnchor.constraint(equalTo: otherLeading,
                                     constant: leading).isActive = true
        }
        
        if let trailing = toTrailing {
            let otherTrailing = safely ?
            otherView.safeAreaLayoutGuide.trailingAnchor : otherView.trailingAnchor
            trailingAnchor.constraint(equalTo: otherTrailing,
                                      constant: trailing).isActive = true
        }
        
    }
}
