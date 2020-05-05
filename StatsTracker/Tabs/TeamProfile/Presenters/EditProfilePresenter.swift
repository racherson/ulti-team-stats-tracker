//
//  EditProfilePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol EditProfilePresenterDelegate: AnyObject {
    func cancelPressed()
    func savePressed(vm: TeamProfileViewModel)
    func backToProfile()
}

class EditProfilePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: EditProfilePresenterDelegate?
    weak var vc: EditProfileViewController!
    let authManager: AuthenticationManager
    var dbManager: DatabaseManager!
    var viewModel: TeamProfileViewModel!
    
    //MARK: Initialization
    init(vc: EditProfileViewController, delegate: EditProfilePresenterDelegate?,
         authManager: AuthenticationManager, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
        self.dbManager = dbManager
        self.dbManager.delegate = self
        
        setDBManager()
    }
    
    //MARK: Private methods
    private func setDBManager() {
        guard let uid = authManager.currentUserUID else {
            // Show error message
            self.showErrorAlert(error: Constants.Errors.userError, title: Constants.Errors.unknown)
            return
        }
        dbManager.uid = uid
    }
    
    private func showErrorAlert(error: String, title: String = Constants.Errors.userSavingError) {
        let alertController = UIAlertController(title: title, message:
            error, preferredStyle: .alert)
        
        // Dismiss and go back to Profile page
        alertController.addAction(UIAlertAction(title: Constants.Alerts.dismiss, style: .default, handler: { (action: UIAlertAction!) in self.backToProfile() }))

        vc.present(alertController, animated: true, completion: nil)
    }
    
    func backToProfile() {
        delegate?.backToProfile()
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
    
    func savePressed(vm: TeamProfileViewModel) {
        // Save new data for later
        self.viewModel = vm
       
        // Store image at a url
        dbManager.storeImage(image: vm.teamImage)
    }
}

//MARK: DatabaseManagerDelegate
extension EditProfilePresenter: DatabaseManagerDelegate {
    
    func displayError(with error: Error) {
        self.showErrorAlert(error: error.localizedDescription)
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
        
        self.delegate?.savePressed(vm: viewModel)
    }
}
