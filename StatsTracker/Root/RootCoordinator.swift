//
//  RootCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit
import FirebaseAuth

class RootCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    //MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = RootViewController.instantiate(.root)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension RootCoordinator {
    
    //MARK: SceneDelegate
    func presentHomeVC() {
        let childNavController = UINavigationController()
        let child = AuthCoordinator(navigationController: childNavController)
        child.delegate = self
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
        childNavController.modalPresentationStyle = .fullScreen
        navigationController.present(childNavController, animated: true, completion: nil)
    }
    
    func presentTabBars() {
        let child = MainTabBarCoordinator(navigationController: navigationController)
        child.delegate = self
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}

extension RootCoordinator: AuthCoordinatorDelegate {
    
    //MARK: AuthCoordinatorDelegate
    func transitionToTabs() {
        navigationController.dismiss(animated: true, completion: nil)
        presentTabBars()
    }
}

extension RootCoordinator: MainTabBarCoordinatorDelegate {
    func transitionToHome() {
        navigationController.dismiss(animated: true, completion: nil)
        presentHomeVC()
    }
}
