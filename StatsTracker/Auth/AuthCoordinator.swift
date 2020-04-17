//
//  AuthCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol AuthCoordinatorDelegate {
    func transitionToTabs()
}

class AuthCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var delegate: AuthCoordinatorDelegate?

    //MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = HomeViewController.instantiate(.auth)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension AuthCoordinator: HomeViewControllerDelegate {
    
    //MARK: HomeViewControllerDelegate
    func signUpPressed() {
        let vc = SignUpViewController.instantiate(.auth)
        vc.delegate = self
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func loginPressed() {
        let vc = LoginViewController.instantiate(.auth)
        vc.delegate = self
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension AuthCoordinator: SignUpAndLoginViewControllerDelegate {
    
    //MARK: SignUpAndLoginViewControllerDelegate
    func cancelPressed() {
        navigationController.popViewController(animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func transitionToTabs() {
        delegate?.transitionToTabs()
    }
}
