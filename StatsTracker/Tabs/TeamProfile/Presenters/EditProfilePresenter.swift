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
    var dbManager: DatabaseManager!
    var viewModel: TeamProfileViewModel!
    var newImage: UIImage?
    
    //MARK: Initialization
    init(vc: EditProfileViewController, delegate: EditProfilePresenterDelegate?, authManager: AuthenticationManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
        
        setDBManager()
    }
    
    //MARK: Private methods
    private func setDBManager() {
        guard let uid = authManager.currentUserUID else {
            self.showErrorAlert(error: Constants.Errors.userError, title: Constants.Errors.unknown)
            return
        }
        dbManager = FirestoreDBManager(uid: uid)
        dbManager.delegate = self
    }
    
    private func showErrorAlert(error: String, title: String = Constants.Errors.userSavingError) {
        let alertController = UIAlertController(title: title, message:
            error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Alerts.dismiss, style: .default))

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
                self.newImage = newImage
                // Update team name and image url in Firestore
                self.dbManager.updateData(data: newData)
            }
        }
    }
}

//MARK: DatabaseManagerDelegate
extension EditProfilePresenter: DatabaseManagerDelegate {
    
    func displayError(with error: Error) {
        guard let dbError = error as? DBError else {
            // Not an DBError specific type
            self.showErrorAlert(error: error.localizedDescription)
            return
        }
        self.showErrorAlert(error: dbError.errorDescription!)
    }
    
    func newData(_ data: [String : Any]) {
        // Hide activity indicator
        self.vc.activityIndicator.stopAnimating()
        self.vc.visualEffectView.alpha = 0
        
        let newName = data[Constants.UserDataModel.teamName] as! String
        if let image = newImage {
            self.delegate?.savePressed(newName: newName, newImage: image)
        }
        else {
            let emptyImage = UIImage(named: Constants.Empty.image)!
            self.delegate?.savePressed(newName: newName, newImage: emptyImage)
        }
    }
}
