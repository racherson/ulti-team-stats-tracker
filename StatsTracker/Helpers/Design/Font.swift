//
//  Font.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

struct Font {
    
    static func profileTitle() -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: Color.teal,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 56)!
        ]
    }
    
    static func largeTitle() -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: Color.teal,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 40)!
        ]
    }
}
