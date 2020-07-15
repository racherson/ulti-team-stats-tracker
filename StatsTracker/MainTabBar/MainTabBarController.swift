//
//  MainTabBarController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol MainTabBarControllerDelegate: AnyObject {
    func transitionToHome()
}

class MainTabBarController: UITabBarController {
    
    //MARK: Properties
    let teamProfileCoordinator = TeamProfileCoordinator(navigationController: NavigationController())
    let rosterCoordinator = RosterCoordinator(navigationController: NavigationController())
    let pullCoordinator = PullCoordinator(navigationController: NavigationController())
    let gamesCoordinator = GamesCoordinator(navigationController: NavigationController())
    weak var coordinator: MainTabBarControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate for team profile (for logout flow)
        teamProfileCoordinator.delegate = self
        pullCoordinator.delegate = self
        
        // Start all of the coordinators (for each tab)
        teamProfileCoordinator.start()
        rosterCoordinator.start()
        pullCoordinator.start()
        gamesCoordinator.start()
        
        // Give the navigation controllers to the tab bar controller
        viewControllers = [teamProfileCoordinator.navigationController, rosterCoordinator.navigationController, pullCoordinator.navigationController, gamesCoordinator.navigationController]
    }
}

//MARK: TeamProfileCoordinatorDelegate
extension MainTabBarController: TeamProfileCoordinatorDelegate {
    func transitionToHome() {
        coordinator?.transitionToHome()
    }
}

//MARK: PullCoordinatorDelegate
extension MainTabBarController: PullCoordinatorDelegate {
    func reloadGames() {
        gamesCoordinator.reloadGames()
        rosterCoordinator.reloadRoster()
    }
}
