//
//  TeamProfileCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class TeamProfileCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = TeamProfileViewController.instantiate(.team)
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.teamProfileTitle, image: UIImage(systemName: "house"), tag: 0)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func settingsPressed() {
        let vc = SettingsTableViewController.instantiate(.team)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}