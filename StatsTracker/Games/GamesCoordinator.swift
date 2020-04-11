//
//  GamesCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class GamesCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = GamesViewController.instantiate(.games)
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.gamesTitle, image: UIImage(systemName: "chart.bar"), tag: 3)
        navigationController.pushViewController(vc, animated: true)
    }
}
