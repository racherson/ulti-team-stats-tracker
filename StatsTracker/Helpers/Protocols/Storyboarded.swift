//
//  Storyboarded.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol Storyboarded {
    
    // Protocol to instantiate a view controller from the storyboard
    static func instantiate(_ board: StoryboardType) -> Self
}

enum StoryboardType: String {
    // Input for the instantiate method for selecting correct storyboard
    case root = "Root"
    case team = "TeamProfile"
    case roster = "Roster"
    case pull = "Pull"
    case games = "Games"
    case auth = "Auth"
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(_ board: StoryboardType) -> Self {
        
        // Pull out "StatsTracker.MyViewController"
        let fullName = NSStringFromClass(self)

        // Split by the dot and use everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // Load correct storyboard
        let storyboard = UIStoryboard(name: board.rawValue, bundle: Bundle.main)

        // Instantiate a view controller with that identifier, and force cast as the type that was requested
        let vc = storyboard.instantiateViewController(withIdentifier: className) as! Self
        
        // Set background color
        vc.view.backgroundColor = AppStyle.topGradientColor
        
        return vc
    }
}
