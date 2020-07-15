//
//  NavigationController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/15/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set font for title
        self.navigationBar.titleTextAttributes = Font.smallTitle
        
        // Set font for navigation bar buttons
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: Font.barButtonItem], for: .normal)
    }
}
