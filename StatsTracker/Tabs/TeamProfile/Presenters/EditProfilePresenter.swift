//
//  EditProfilePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol EditProfilePresenterDelegate: AnyObject {
    func cancelPressed()
    func savePressed(newName: String, newImage: UIImage)
}

class EditProfilePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: EditProfilePresenterDelegate?
    weak var vc: EditProfileViewController!
    let authManager: AuthenticationManager
    var viewModel: TeamProfileViewModel!
    
    //MARK: Initialization
    init(vc: EditProfileViewController, delegate: EditProfilePresenterDelegate?, authManager: AuthenticationManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
    }
    
    //MARK: Private methods
    private func showErrorAlert(error: String) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.userSavingError, message:
            error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        vc.present(alertController, animated: true, completion: nil)
    }
}

//MARK: EditProfilePresenterProtocol
extension EditProfilePresenter: EditProfilePresenterProtocol {
    
    func onViewWillAppear() {
        // Give view controller new view model
        vc.updateWithViewModel(vm: viewModel)
    }
    
    func cancelPressed() {
        delegate?.cancelPressed()
    }
    
    func savePressed(newName: String, newImage: UIImage) {
        // Find the current uid
        guard let uid = authManager.currentUserUID else {
            return
        }
        
        // Convert image to data to store
        guard let data = newImage.jpegData(compressionQuality: 1.0) else {
            self.showErrorAlert(error: Constants.Errors.unknown)
            return
        }
        
        // Store image under the current user uid
        let imageReference = Storage.storage()
            .reference()
            .child(FirebaseKeys.CollectionPath.imagesFolder)
            .child(uid)
        
        // Store the image data in storage
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                self.showErrorAlert(error: err.localizedDescription)
                return
            }
            
            // Get the image url
            imageReference.downloadURL { (url, err) in
                if let err = err {
                    self.showErrorAlert(error: err.localizedDescription)
                    return
                }
                guard let url = url else {
                    self.showErrorAlert(error: Constants.Errors.unknown)
                    return
                }
                
                let urlString = url.absoluteString
                let newData = [
                    Constants.UserDataModel.imageURL: urlString,
                    Constants.UserDataModel.teamName: newName
                ]
                
                // Update team name and image url in Firestore
                FirestoreReferenceManager.referenceForUserPublicData(uid: uid).updateData(newData) { (error) in
                        if error != nil {
                            self.showErrorAlert(error: error!.localizedDescription)
                            return
                        }
                        
                        // Hide activity indicator
                        self.vc.activityIndicator.stopAnimating()
                        self.vc.visualEffectView.alpha = 0
                        self.delegate?.savePressed(newName: newName, newImage: newImage)
                }
            }
        }
    }
}
