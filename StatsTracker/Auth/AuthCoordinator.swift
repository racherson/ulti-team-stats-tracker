//
//  AuthCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class AuthCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    //MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = RootViewController.instantiate(.auth)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    //MARK: Delegate
    func signUpPressed() {
        let vc = SignUpViewController.instantiate(.auth)
        vc.coordinator = self
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func loginPressed() {
        let vc = LoginViewController.instantiate(.auth)
        vc.coordinator = self
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func cancelPressed() {
        navigationController.popViewController(animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
    }
}
