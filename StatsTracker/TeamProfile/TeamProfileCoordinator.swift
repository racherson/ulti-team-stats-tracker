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
    var authManager: AuthenticationManager?
    var teamImage: UIImage? = Constants.Loading.image! {
        didSet {
            updateTPViewModel()
        }
    }
    var teamName: String? = Constants.Loading.string {
        didSet {
            updateTPViewModel()
        }
    }

    // MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        
        // Get name from Firebase
        if let uid = authManager?.currentUserUID {
            FirestoreReferenceManager.referenceForUserPublicData(uid: uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    // Give coordinator the fetched team name
                    self.teamName = document.get(FirebaseKeys.Users.teamName) as? String
                } else {
                    fatalError(Constants.Errors.documentError)
                }
            }
        }
        
        // Create new view controller
        let vc = TeamProfileViewController.instantiate(.team)
        vc.delegate = self
        
        // Create tab item
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.teamProfileTitle, image: UIImage(systemName: "house"), tag: 0)
        navigationController.pushViewController(vc, animated: true)
        vc.viewModel = TeamProfileViewModel(team: teamName!, image: teamImage!)
    }
    
    func updateTPViewModel() {
        // Make sure bottom view controller is TeamProfileViewController
        guard let teamProfileVC = navigationController.viewControllers[0] as? TeamProfileViewController else { return }
        
        // Give the view controller a new view model
        teamProfileVC.viewModel = TeamProfileViewModel(team: teamName!, image: teamImage!)
    }
}

//MARK: TeamProfileViewControllerDelegate
extension TeamProfileCoordinator: TeamProfileViewControllerDelegate {
    
    func settingsPressed() {
        let vc = SettingsViewController.instantiate(.team)
        vc.delegate = self
        vc.authManager = FirebaseAuthManager()
        navigationController.pushViewController(vc, animated: true)
    }
}

//MARK: SettingsViewControllerDelegate
extension TeamProfileCoordinator: SettingsViewControllerDelegate {
    func transitionToHome() {
        delegate?.transitionToHome()
    }
    
    func editPressed() {
        let vc = EditProfileViewController.instantiate(.team)
        let navController = UINavigationController(rootViewController: vc)
        vc.delegate = self
        vc.teamName = teamName
        vc.teamImage = teamImage
        navigationController.present(navController, animated: true, completion: nil)
    }
}

//MARK: EditProfileViewControllerDelegate
extension TeamProfileCoordinator: EditProfileViewControllerDelegate {

    func cancelPressed() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func savePressed(newName: String, newImage: UIImage) {
        
        // Update team name for current user in Firestore
        if let uid = authManager?.currentUserUID {
            FirestoreReferenceManager.referenceForUserPublicData(uid: uid).updateData([FirebaseKeys.Users.teamName: newName]) { (error) in
                if error != nil {
                    fatalError(Constants.Errors.userSavingError)
                }
            }
        }
        
        // Give new name and image to coordinator
        teamName = newName
        teamImage = newImage
        
        // Return to TeamProfileViewController
        navigationController.dismiss(animated: true, completion: nil)
        navigationController.popViewController(animated: true)
    }
}
