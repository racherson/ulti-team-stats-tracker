//
//  TeamProfileCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol TeamProfileCoordinatorDelegate: AnyObject {
    func transitionToHome()
}

class TeamProfileCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var delegate: TeamProfileCoordinatorDelegate?
    let authManager: AuthenticationManager = FirebaseAuthManager()
    var rootVC: TeamProfileViewController!
    var viewModel: TeamProfileViewModel?

    // MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        self.setLargeTitles()
        
        // Create new view controller
        let vc = TeamProfileViewController.instantiate(.team)
        vc.presenter = TeamProfilePresenter(vc: vc, delegate: self, dbManager: FirestoreDBManager(authManager.currentUserUID))
        
        // Create tab item
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.teamProfileTitle, image: UIImage(systemName: "house"), tag: 0)
        rootVC = vc
        
        navigationController.pushViewController(vc, animated: true)
    }
}

//MARK: TeamProfileViewControllerDelegate
extension TeamProfileCoordinator: TeamProfilePresenterDelegate {
    
    func settingsPressed(vm: TeamProfileViewModel) {
        // Give coordinator current view model
        viewModel = vm
        
        // Push settings view
        let vc = SettingsViewController.instantiate(.team)
        vc.presenter = SettingsPresenter(vc: vc, delegate: self, authManager: authManager)
        navigationController.pushViewController(vc, animated: true)
    }
}

//MARK: SettingsViewControllerDelegate
extension TeamProfileCoordinator: SettingsPresenterDelegate {
    func transitionToHome() {
        delegate?.transitionToHome()
    }
    
    func editPressed() {
        let vc = EditProfileViewController.instantiate(.team)
        let navController = UINavigationController(rootViewController: vc)
        let presenter = EditProfilePresenter(vc: vc, delegate: self, dbManager: FirestoreDBManager(authManager.currentUserUID))
        presenter.viewModel = viewModel
        vc.presenter = presenter
        navigationController.present(navController, animated: true, completion: nil)
    }
}

//MARK: EditProfileViewControllerDelegate
extension TeamProfileCoordinator: EditProfilePresenterDelegate {

    func cancelPressed() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func savePressed(vm: TeamProfileViewModel) {
        // Give new view model to coordinator
        viewModel = vm
        
        // Give new view model to TeamProfilePresenter to update view
        rootVC.presenter.viewModel = viewModel
        
        // Return to TeamProfileViewController
        backToProfile()
    }
    
    func backToProfile() {
        // Return to TeamProfileViewController
        navigationController.dismiss(animated: true, completion: nil)
        navigationController.popViewController(animated: true)
    }
}
