//
//  TeamProfileCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol TeamProfileCoordinatorDelegate: class {
    func transitionToHome()
}

class TeamProfileCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var delegate: TeamProfileCoordinatorDelegate?

    // MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Create new view controller
        let vc = TeamProfileViewController.instantiate(.team)
        vc.presenter = TeamProfilePresenter(vc: vc, delegate: self, authManager: FirebaseAuthManager())
        
        // Create tab item
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.teamProfileTitle, image: UIImage(systemName: "house"), tag: 0)
        navigationController.pushViewController(vc, animated: true)
    }
}

//MARK: TeamProfileViewControllerDelegate
extension TeamProfileCoordinator: TeamProfilePresenterDelegate {
    
    func settingsPressed() {
        let vc = SettingsViewController.instantiate(.team)
        vc.presenter = SettingsPresenter(vc: vc, delegate: self, authManager: FirebaseAuthManager())
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
        vc.presenter = EditProfilePresenter(vc: vc, delegate: self, authManager: FirebaseAuthManager())
//        vc.teamName = teamName
//        vc.teamImage = teamImage
        navigationController.present(navController, animated: true, completion: nil)
    }
}

//MARK: EditProfileViewControllerDelegate
extension TeamProfileCoordinator: EditProfilePresenterDelegate {

    func cancelPressed() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func savePressed(newName: String, newImage: UIImage) {
        
        // Give new name and image to coordinator
//        teamName = newName
//        teamImage = newImage
        
        // Return to TeamProfileViewController
        navigationController.dismiss(animated: true, completion: nil)
        navigationController.popViewController(animated: true)
    }
}
