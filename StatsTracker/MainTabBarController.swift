//
//  MainTabBarController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK: Properties
    let teamProfileCoordinator = TeamProfileCoordinator(navigationController: UINavigationController())
    let rosterCoordinator = RosterCoordinator(navigationController: UINavigationController())
    let pullCoordinator = PullCoordinator(navigationController: UINavigationController())
    let gamesCoordinator = GamesCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start all of the coordinators (for each tab)
        teamProfileCoordinator.start()
        rosterCoordinator.start()
        pullCoordinator.start()
        gamesCoordinator.start()
        
        // Give the navigation controllers to the tab bar controller
        viewControllers = [teamProfileCoordinator.navigationController, rosterCoordinator.navigationController, pullCoordinator.navigationController, gamesCoordinator.navigationController]
    }
}
