//
//  EditProfilePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol EditProfilePresenterDelegate: class {
    func cancelPressed()
    func savePressed(newName: String, newImage: UIImage)
}

class EditProfilePresenter {
    
    //MARK: Properties
    weak var delegate: EditProfilePresenterDelegate?
    let vc: EditProfileViewController
    let authManager: AuthenticationManager
    var viewModel: TeamProfileViewModel!
    
    //MARK: Initialization
    init(vc: EditProfileViewController, delegate: EditProfilePresenterDelegate?, authManager: AuthenticationManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
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
            fatalError(Constants.Errors.userSavingError)
        }
        
        // Store image under the current user uid
        let imageReference = Storage.storage()
            .reference()
            .child(FirebaseKeys.CollectionPath.imagesFolder)
            .child(uid)
        
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
                
                // Update team name and image url in Firestore
                FirestoreReferenceManager.referenceForUserPublicData(uid: uid)
                    .updateData([
                        FirebaseKeys.Users.imageURL: urlString,
                        FirebaseKeys.Users.teamName: newName
                    ]) { (error) in
                        if error != nil {
                            fatalError(Constants.Errors.userSavingError)
                        }
                        self.vc.activityIndicator.stopAnimating()
                        self.vc.visualEffectView.alpha = 0
                        self.delegate?.savePressed(newName: newName, newImage: newImage)
                }
            }
        }
    }
}
