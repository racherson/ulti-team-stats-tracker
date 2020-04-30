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
        // Save new data for later
        self.viewModel = TeamProfileViewModel(team: newName, image: newImage)
       
        // Store image at a url
        dbManager.storeImage(image: newImage)
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
    
    func storeImageURL(url: String) {
        let newData = [
            Constants.UserDataModel.imageURL: url,
            Constants.UserDataModel.teamName: viewModel.teamName
            ]
        // Update team name and image url in Firestore
        dbManager.updateData(data: newData)
    }
    
    func newData(_ data: [String : Any]?) {
        // Hide activity indicator
        self.vc.activityIndicator.stopAnimating()
        self.vc.visualEffectView.alpha = 0
        
        self.delegate?.savePressed(newName: viewModel.teamName, newImage: viewModel.teamImage)
    }
}
