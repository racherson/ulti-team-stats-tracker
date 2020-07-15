//
//  Font.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

struct Font {
    
    static var profileTitle: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: AppStyle.accentColor,
            NSAttributedString.Key.font: UIFont(name: AppStyle.Font.bold, size: 56)!
        ]
    }
    
    static var largeTitle: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: AppStyle.accentColor,
            NSAttributedString.Key.font: UIFont(name: AppStyle.Font.bold, size: 40)!
        ]
    }
    
    static var smallTitle: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: AppStyle.accentColor,
            NSAttributedString.Key.font: UIFont(name: AppStyle.Font.bold, size: 18)!
        ]
    }
    
    static var subTitle: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: AppStyle.accentColor,
            NSAttributedString.Key.font: UIFont(name: AppStyle.Font.bold, size: 17)!
        ]
    }
    
    static var tableView: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: AppStyle.accentColor,
            NSAttributedString.Key.font: UIFont(name: AppStyle.Font.medium, size: 18)!
        ]
    }
    
    static var segmentedControl: UIFont {
        return UIFont(name: AppStyle.Font.regular, size: 16.0)!
    }
    
    static var barButtonItem: UIFont {
        return UIFont(name: AppStyle.Font.medium, size: 17.0)!
    }
}
