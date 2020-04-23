//
//  AuthCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol AuthCoordinatorDelegate: class {
    func transitionToTabs()
}

class AuthCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: RootCoordinator?
    weak var delegate: AuthCoordinatorDelegate?

    //MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = HomeViewController.instantiate(.auth)
        vc.delegate = self
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }
}

//MARK: HomeViewControllerDelegate
extension AuthCoordinator: HomeViewControllerDelegate {
    
    func signUpPressed() {
        let vc = SignUpViewController.instantiate(.auth)
        vc.presenter = SignUpPresenter(vc: vc, delegate: self, authManager: FirebaseAuthManager())
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func loginPressed() {
        let vc = LoginViewController.instantiate(.auth)
        vc.presenter = LoginPresenter(vc: vc, delegate: self, authManager: FirebaseAuthManager())
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }
}

//MARK: SignUpAndLoginViewControllerDelegate
extension AuthCoordinator: SignUpAndLoginPresenterDelegate {

    func cancelPressed() {
        navigationController.popViewController(animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func transitionToTabs() {
        parentCoordinator?.childDidFinish(self)
        delegate?.transitionToTabs()
    }
}
