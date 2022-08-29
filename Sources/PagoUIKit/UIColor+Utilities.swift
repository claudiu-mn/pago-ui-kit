//
//  UIColor+Utilities.swift
//  
//
//  Created by Claudiu Miron on 22.08.2022.
//

import UIKit

// A little bit from https://stackoverflow.com/a/24263296 and
// a little bit from https://cocoacasts.com/from-hex-to-uicolor-and-back-in-swift
public extension UIColor {
    convenience init(red: UInt8, green: UInt8, blue: UInt8) {
        self.init(red: red, green: green, blue: blue, alpha: UInt8.max)
    }
    
    convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.init(red: red.normalizedColorComponent,
                  green: green.normalizedColorComponent,
                  blue: blue.normalizedColorComponent,
                  alpha: alpha.normalizedColorComponent)
    }
    
    convenience init(rgb: Int) {
        self.init(red: rgb.redChannel,
                  green: rgb.greenChannel,
                  blue: rgb.blueChannel)
    }
}

extension UInt8 {
    var normalizedColorComponent: CGFloat {
        get {
            return CGFloat(self) / CGFloat(UInt8.max)
        }
    }
}

// TODO: What about when we want alpha?
extension Int {
    var redChannel: UInt8 {
        get {
            return UInt8((self & 0xFF0000) >> 16)
        }
    }
    
    var greenChannel: UInt8 {
        get {
            return UInt8((self & 0x00FF00) >> 8)
        }
    }
    
    var blueChannel: UInt8 {
        get {
            return UInt8((self & 0x0000FF) >> 0)
        }
    }
}
