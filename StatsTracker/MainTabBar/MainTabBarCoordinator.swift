//
//  MainTabBarCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol MainTabBarCoordinatorDelegate {
    func transitionToHome()
}

class MainTabBarCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: RootCoordinator?
    var delegate: MainTabBarCoordinatorDelegate?

    //MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = MainTabBarController()
        vc.modalPresentationStyle = .fullScreen
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }
}

//MARK: MainTabBarControllerDelegate
extension MainTabBarCoordinator: MainTabBarControllerDelegate {
    
    func transitionToHome() {
        parentCoordinator?.childDidFinish(self)
        delegate?.transitionToHome()
    }
}

