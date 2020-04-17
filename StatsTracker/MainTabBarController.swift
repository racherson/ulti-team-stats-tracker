//
//  MainTabBarController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol MainTabBarControllerDelegate {
    func transitionToHome()
}

class MainTabBarController: UITabBarController {
    
    //MARK: Properties
    let teamProfileCoordinator = TeamProfileCoordinator(navigationController: UINavigationController())
    let rosterCoordinator = RosterCoordinator(navigationController: UINavigationController())
    let pullCoordinator = PullCoordinator(navigationController: UINavigationController())
    let gamesCoordinator = GamesCoordinator(navigationController: UINavigationController())
    var coordinator: MainTabBarControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate for team profile (for logout flow)
        teamProfileCoordinator.delegate = self
        
        // Start all of the coordinators (for each tab)
        teamProfileCoordinator.start()
        rosterCoordinator.start()
        pullCoordinator.start()
        gamesCoordinator.start()
        
        // Give the navigation controllers to the tab bar controller
        viewControllers = [teamProfileCoordinator.navigationController, rosterCoordinator.navigationController, pullCoordinator.navigationController, gamesCoordinator.navigationController]
    }
}

extension MainTabBarController: TeamProfileCoordinatorDelegate {
    func transitionToHome() {
        coordinator?.transitionToHome()
    }
}
