//
//  Storyboarded.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol Storyboarded {
    // Protocol from https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps
    
    static func instantiate(_ board: StoryboardType) -> Self
}

enum StoryboardType: String {
    // Input for the instantiate method for selecting correct storyboard
    case main = "Main"
    case settings = "Settings"
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(_ board: StoryboardType) -> Self {
        // this pulls out "StatsTracker.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load correct storyboard
        let storyboard = UIStoryboard(name: board.rawValue, bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
