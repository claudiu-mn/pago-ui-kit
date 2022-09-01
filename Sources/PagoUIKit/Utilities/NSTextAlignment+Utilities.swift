//
//  NSTextAlignment+Utilities.swift
//  
//
//  Created by Claudiu Miron on 01.09.2022.
//

import UIKit

extension NSTextAlignment {
    static var unnatural: NSTextAlignment {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .left : .right
    }
}
