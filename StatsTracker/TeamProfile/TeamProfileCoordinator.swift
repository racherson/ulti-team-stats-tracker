//
//  TeamProfileCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Kingfisher

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
        // Set the coordinator team name and image
        setData()
        
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
    
    func setData() {
        // Get the current user uid
        guard let uid = authManager?.currentUserUID else {
            fatalError("Something went wrong")
        }
        FirestoreReferenceManager.referenceForUserPublicData(uid: uid).getDocument { (document, error) in
            if error != nil {
                fatalError(Constants.Errors.documentError)
            }
            guard let document = document,
                // grab the team name and image url
                let name = document.get(FirebaseKeys.Users.teamName) as? String,
                let urlString = document.get(FirebaseKeys.Users.imageURL) as? String else {
                    fatalError(Constants.Errors.documentError)
            }
            // Give data to the coordinator
            self.teamName = name
            self.downloadImage(with: urlString)
        }
    }
    
    func downloadImage(`with` urlString: String) {
        // Use url string to get true url
        guard let url = URL(string: urlString) else {
            return
        }

        // Retrieve the image from the url
        KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: url), options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self.teamImage = value.image
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
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
            FirestoreReferenceManager.referenceForUserPublicData(uid: uid)
                .updateData([FirebaseKeys.Users.teamName: newName]) { (error) in
                if error != nil {
                    fatalError(Constants.Errors.userSavingError)
                }
            }
        }
        
        // Update team image for current user in Firestore
        guard let data = newImage.jpegData(compressionQuality: 1.0) else {
            fatalError(Constants.Errors.userSavingError)
        }
        
        // Store image under the current user uid
        if let imageName = authManager?.currentUserUID {
            let imageReference = Storage.storage()
            .reference()
            .child(FirebaseKeys.CollectionPath.imagesFolder)
            .child(imageName)
            
            // Store the image data in storage
            imageReference.putData(data, metadata: nil) { (metadata, err) in
                if let err = err {
                    fatalError(err.localizedDescription)
                }
                
                // Get the image url
                imageReference.downloadURL { (url, err) in
                    if let err = err {
                        fatalError(err.localizedDescription)
                    }
                    guard let url = url else {
                        fatalError("Something went wrong")
                    }
                    
                    let urlString = url.absoluteString
                    
                    // Update imageURL in Firestore
                    FirestoreReferenceManager.referenceForUserPublicData(uid: imageName)
                        .updateData([FirebaseKeys.Users.imageURL: urlString]) { (error) in
                        if error != nil {
                            fatalError(Constants.Errors.userSavingError)
                        }
                    }
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
