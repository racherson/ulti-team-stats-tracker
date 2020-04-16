//
//  TeamProfileCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

protocol TeamProfileCoordinatorDelegate {
    func transitionToHome()
}

class TeamProfileCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var delegate: TeamProfileCoordinatorDelegate?
    var teamName: String?

    // MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Get name from Firebase
        if let uid = Auth.auth().currentUser?.uid {
            FirestoreReferenceManager.referenceForUserPublicData(uid: uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    self.teamName = document.get(FirebaseKeys.Users.teamName) as? String
                } else {
                    fatalError(Constants.Errors.documentError)
                }
            }
        }
        
        let vc = TeamProfileViewController.instantiate(.team)
        vc.delegate = self
        
        // Create tab item
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
    
    func viewWillAppear() {
        guard let vc = navigationController.viewControllers[0] as? TeamProfileViewController else {
            fatalError(Constants.Errors.viewControllerError)
        }
        vc.updateWithViewModel(vm: TeamProfileViewModel(teamName: teamName ?? Constants.Titles.defaultTeamName))
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
        // Update team name for user in Firestore
        if let uid = Auth.auth().currentUser?.uid {
            FirestoreReferenceManager.referenceForUserPublicData(uid: uid).updateData([FirebaseKeys.Users.teamName: newName]) { (error) in
                if error != nil {
                    fatalError(Constants.Errors.userSavingError)
                }
            }
        }
        
        // Give new name to coordinator
        teamName = newName
        
        // Return to TeamProfileViewController
        navigationController.dismiss(animated: true, completion: nil)
        navigationController.popViewController(animated: true)
    }
}
