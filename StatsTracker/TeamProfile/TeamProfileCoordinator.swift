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

    // MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = TeamProfileViewController.instantiate(.team)
        vc.delegate = self
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.teamProfileTitle, image: UIImage(systemName: "house"), tag: 0)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension TeamProfileCoordinator: TeamProfileViewControllerDelegate {
    
    //MARK: TeamProfileViewControllerDelegate
    func settingsPressed() {
        let vc = SettingsViewController.instantiate(.team)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}
