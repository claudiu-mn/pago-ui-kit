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
    func stick(to otherView: UIView,
               safely: Bool = true,
               atTop: CGFloat? = nil,
               atLeading: CGFloat? = nil,
               atBottom: CGFloat? = nil,
               atTrailing: CGFloat? = nil) {
        if atTop == nil && atLeading == nil && atBottom == nil && atTrailing == nil {
            return
        }
        
        if let top = atTop {
            let otherTop = safely ?
            otherView.safeAreaLayoutGuide.topAnchor : otherView.topAnchor
            topAnchor.constraint(equalTo: otherTop,
                                 constant: top).isActive = true
        }
        
        if let bottom = atBottom {
            let otherBottom = safely ?
            otherView.safeAreaLayoutGuide.bottomAnchor : otherView.bottomAnchor
            bottomAnchor.constraint(equalTo: otherBottom,
                                    constant: bottom).isActive = true
        }
        
        if let leading = atLeading {
            let otherLeading = safely ?
            otherView.safeAreaLayoutGuide.leadingAnchor : otherView.leadingAnchor
            leadingAnchor.constraint(equalTo: otherLeading,
                                     constant: leading).isActive = true
        }
        
        if let trailing = atTrailing {
            let otherTrailing = safely ?
            otherView.safeAreaLayoutGuide.trailingAnchor : otherView.trailingAnchor
            trailingAnchor.constraint(equalTo: otherTrailing,
                                      constant: trailing).isActive = true
        }
        
    }
}
