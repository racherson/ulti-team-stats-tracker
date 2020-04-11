//
//  RosterCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class RosterCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = RosterViewController.instantiate(.roster)
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.rosterTitle, image: UIImage(systemName: "person.3"), tag: 1)
        navigationController.pushViewController(vc, animated: true)
    }
    
    //MARK: Delegate
    func buySubscription() {
        let vc = BuyViewController.instantiate(.roster)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func createAccount() {
        let vc = CreateAccountViewController.instantiate(.roster)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
