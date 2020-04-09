//
//  SettingsCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SettingsViewController.instantiate(.settings)
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
        navigationController.pushViewController(vc, animated: false)
    }
}
