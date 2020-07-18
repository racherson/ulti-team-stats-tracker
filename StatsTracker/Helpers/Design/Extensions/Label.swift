//
//  Label.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/15/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

//MARK: UILabel
extension UILabel {
    // Change label font
    @objc var substituteFontName : String {
        get {
            return self.font.fontName
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased()
            var fontName = newValue
            if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular"
            } else if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light"
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight"
            }
            self.font = UIFont(name: fontName, size: self.font.pointSize)
        }
    }
}

//MARK: UITextView
extension UITextView {
    // Change text view font
    @objc var substituteFontName : String {
        get {
            return self.font?.fontName ?? ""
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? ""
            var fontName = newValue
            if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular"
            } else if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light"
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight"
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

//MARK: UITextField
extension UITextField {
    // Change text field font
    @objc var substituteFontName : String {
        get {
            return self.font?.fontName ?? ""
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? ""
            var fontName = newValue
            if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular"
            } else if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light"
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight"
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
    
    // Change text field font color
    @objc var substituteTextColor : UIColor {
        get {
            return self.textColor ?? AppStyle.accentColor
        }
        set {
            self.textColor = newValue
        }
    }
}
