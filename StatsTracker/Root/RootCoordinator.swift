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
    private let window: UIWindow
    private let authManager: AuthenticationManager = FirebaseAuthManager()

    //MARK: Initialization
    init(navigationController: UINavigationController = UINavigationController(), window: UIWindow) {
        
        navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController = navigationController
        self.window = window
        setupWindow()
    }
    
    func setupWindow() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }

    func start() {
        let vc = RootViewController.instantiate(.root)
        navigationController.pushViewController(vc, animated: true)
        setupStarterCoordinator()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func setupStarterCoordinator() {
        // Check log in status
        if authManager.currentUserUID == nil {
            // No user is logged in
            presentHomeVC()
        }
        else {
            // User is logged in
            presentTabBars()
        }
    }
}

extension RootCoordinator {
    
    func presentHomeVC() {
        let childNavController = UINavigationController()
        childNavController.modalPresentationStyle = .fullScreen
        let child = AuthCoordinator(navigationController: childNavController)
        child.delegate = self
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
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

//MARK: AuthCoordinatorDelegate
extension RootCoordinator: AuthCoordinatorDelegate {
    
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
