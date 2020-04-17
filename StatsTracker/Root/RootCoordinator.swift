//
//  RootCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

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
}

extension RootCoordinator {
    
    //MARK: SceneDelegate
    func presentHomeVC() {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        navController.modalPresentationStyle = .fullScreen
        
        // Start auth coordinator for login flow
        let authCoordinator = AuthCoordinator(navigationController: navController)
        authCoordinator.delegate = self
        authCoordinator.start()
        
        navigationController.present(navController, animated: true, completion: nil)
    }
    
    func presentTabBars() {
        let vc = MainTabBarController()
        vc.modalPresentationStyle = .fullScreen
        vc.coordinator = self
        
        navigationController.present(vc, animated: true, completion: nil)
    }
}

extension RootCoordinator: AuthCoordinatorDelegate {
    
    //MARK: AuthCoordinatorDelegate
    func transitionToTabs() {
        navigationController.dismiss(animated: true, completion: nil)
        presentTabBars()
    }
}

extension RootCoordinator: MainTabBarControllerDelegate {
    
    //MARK: MainTabBarControllerDelegate
    func transitionToHome() {
        navigationController.dismiss(animated: true, completion: nil)
        presentHomeVC()
    }
}
