//
//  TeamProfilePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import Kingfisher

protocol TeamProfilePresenterDelegate: AnyObject {
    func settingsPressed(vm: TeamProfileViewModel)
}

class TeamProfilePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: TeamProfilePresenterDelegate?
    weak var vc: TeamProfileViewController!
    var authManager: AuthenticationManager!
    var dbManager: DatabaseManager!
    var viewModel: TeamProfileViewModel? {
        didSet {
            self.onViewWillAppear()
        }
    }
    
    //MARK: Initialization
    init(vc: TeamProfileViewController, delegate: TeamProfilePresenterDelegate?, authManager: AuthenticationManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
        
        initializeViewModel()
    }
    
    //MARK: Private methods
    private func initializeViewModel() {
        // Get the current user uid
        guard let uid = authManager.currentUserUID else {
            displayError(with: AuthError.user)
            return
        }
        
        self.dbManager = FirestoreDBManager(uid: uid)
        dbManager.delegate = self
        dbManager.getData()
    }
    
    private func setViewModel(urlString: String, name: String) {
        // Use url string to get true url
        guard let url = URL(string: urlString) else {
            self.viewModel = TeamProfileViewModel(team: name, image: UIImage(named: Constants.Empty.image)!)
            return
        }

        // Retrieve the image from the url
        KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: url), options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self.viewModel = TeamProfileViewModel(team: name, image: value.image)
            case .failure( _):
                self.viewModel = TeamProfileViewModel(team: name, image: UIImage(named: Constants.Empty.image)!)
            }
        }
    }
    
    private func showErrorAlert(error: String) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.logoutError, message:
            error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Alerts.dismiss, style: .default))

        vc.present(alertController, animated: true, completion: nil)
    }
}

//MARK: TeamProfilePresenterProtocol
extension TeamProfilePresenter: TeamProfilePresenterProtocol {
    func onViewWillAppear() {
        if viewModel == nil {
            // Start loading state
            vc.loadingState()
        }
        else {
            // Give view controller new view model
            vc.updateWithViewModel(viewModel: viewModel!)
        }
    }
    
    func settingsPressed() {
        delegate?.settingsPressed(vm: viewModel!)
    }
}

extension TeamProfilePresenter: DatabaseManagerDelegate {
    func newData(_ data: [String: Any]) {
        let url = data[Constants.UserDataModel.imageURL] as! String
        let name = data[Constants.UserDataModel.teamName] as! String
        setViewModel(urlString: url, name: name)
    }
    
    func displayError(with error: Error) {
        guard let dbError = error as? DBError else {
            // Not an DBError specific type
            self.showErrorAlert(error: error.localizedDescription)
            return
        }
        self.showErrorAlert(error: dbError.errorDescription!)
    }
}
