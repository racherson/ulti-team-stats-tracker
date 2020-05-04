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

    //MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        setLargeTitles()
        
        // Create new view controller
        let vc = RosterViewController.instantiate(.roster)
        vc.delegate = self
        
        // Create tab item
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.rosterTitle, image: UIImage(systemName: "person.3"), tag: 1)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
}
