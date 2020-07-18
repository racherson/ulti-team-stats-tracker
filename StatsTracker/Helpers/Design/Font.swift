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
    
    static var tableView: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: AppStyle.accentColor,
            NSAttributedString.Key.font: UIFont(name: AppStyle.Font.medium, size: 18)!
        ]
    }
    
    static var segmentedControl: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: AppStyle.accentColor,
            NSAttributedString.Key.font: UIFont(name: AppStyle.Font.regular, size: 16)!
        ]
    }
    
    static var barButtonItem: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: AppStyle.accentColor,
            NSAttributedString.Key.font: UIFont(name: AppStyle.Font.medium, size: 17)!
        ]
    }
}
