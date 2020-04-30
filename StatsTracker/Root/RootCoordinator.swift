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
    var authManager: AuthenticationManager = FirebaseAuthManager()

    //MARK: Initialization
    init(navigationController: UINavigationController = UINavigationController(), window: UIWindow) {
        
        navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController = navigationController
        self.window = window
        setupWindow()
    }

    func start() {
        let vc = RootViewController.instantiate(.root)
        navigationController.pushViewController(vc, animated: true)
        setupStarterChildCoordinator()
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
    
    func setupWindow() {
        // Attach view to window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func setupStarterChildCoordinator() {
        // Select child coordinator based on login status
        if authManager.currentUserUID == nil {
            startAuthCoordinator()
        }
        else {
            startMainTabBarCoordinator()
        }
    }
    
    func startAuthCoordinator() {
        // Start login flow
        let childNavController = UINavigationController()
        childNavController.modalPresentationStyle = .fullScreen
        let child = AuthCoordinator(navigationController: childNavController)
        child.delegate = self
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
        navigationController.present(childNavController, animated: true, completion: nil)
    }
    
    func startMainTabBarCoordinator() {
        // User logged in, go to tabs
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
        startMainTabBarCoordinator()
    }
}

//MARK: MainTabBarCoordinatorDelegate
extension RootCoordinator: MainTabBarCoordinatorDelegate {
    func transitionToHome() {
        navigationController.dismiss(animated: true, completion: nil)
        startAuthCoordinator()
    }
}
