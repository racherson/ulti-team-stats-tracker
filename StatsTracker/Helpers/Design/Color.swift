//
//  Color.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

struct Color {
    
    // Color literals
    static let teal = UIColor(red: 0.03, green: 0.31, blue: 0.42, alpha: 1.0)
    static let seafoam = UIColor(red: 0.7373, green: 1, blue: 0.9412, alpha: 1.0)
    static let dark_seafom = UIColor(red: 0.3176, green: 0.8, blue: 0.6706, alpha: 1.0)
    
    static func setGradient(view: UIView) {
        // Create gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [AppStyle.topGradientColor.cgColor, AppStyle.bottomGradientColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        
        if let tableView = view as? UITableView {
            // If the view is a tableview, set the tableview background view
            let backgroundView = UIView(frame: view.bounds)
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            tableView.backgroundView = backgroundView
        }
        else {
            view.layer.insertSublayer(gradientLayer, at:0)
        }
    }
}
