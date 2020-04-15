//
//  TeamProfileCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol TeamProfileCoordinatorDelegate {
    func transitionToHome()
}

class TeamProfileCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var delegate: TeamProfileCoordinatorDelegate?

    // MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = TeamProfileViewController.instantiate(.team)
        vc.delegate = self
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.teamProfileTitle, image: UIImage(systemName: "house"), tag: 0)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension TeamProfileCoordinator: TeamProfileViewControllerDelegate {
    
    //MARK: TeamProfileViewControllerDelegate
    func settingsPressed() {
        let vc = SettingsViewController.instantiate(.team)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension TeamProfileCoordinator: SettingsViewControllerDelegate {
    func transitionToHome() {
        delegate?.transitionToHome()
    }
    
    func editPressed() {
        let vc = EditProfileViewController.instantiate(.team)
        let navController = UINavigationController(rootViewController: vc)
        vc.delegate = self
        navigationController.present(navController, animated: true, completion: nil)
    }
}

extension TeamProfileCoordinator: EditProfileViewControllerDelegate {

    func cancelPressed() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func savePressed(newName: String) {
        // Get current user
        if let uid = Auth.auth().currentUser?.uid {
            // Update team name for user in Firestore
            FirestoreReferenceManager.referenceForUserPublicData(uid: uid).updateData([FirebaseKeys.FieldName.teamName: newName]) { (error) in
                if error != nil {
                    fatalError(Constants.Errors.userSavingError)
                }
            }
        }
        
        // Return to TeamProfileViewController
        navigationController.dismiss(animated: true, completion: nil)
        navigationController.popViewController(animated: true)
    }
}
