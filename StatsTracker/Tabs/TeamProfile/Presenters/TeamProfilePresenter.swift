//
//  TeamProfilePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol TeamProfilePresenterDelegate: AnyObject {
    func settingsPressed(vm: TeamProfileViewModel)
}

class TeamProfilePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: TeamProfilePresenterDelegate?
    weak var vc: TeamProfileViewController!
    var dbManager: DatabaseManager!
    var viewModel: TeamProfileViewModel? {
        didSet {
            self.onViewWillAppear()
        }
    }
    
    //MARK: Initialization
    init(vc: TeamProfileViewController, delegate: TeamProfilePresenterDelegate?, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.dbManager = dbManager
        self.dbManager.delegate = self
        
        initializeViewModel()
    }
    
    //MARK: Private methods
    private func initializeViewModel() {
        dbManager.getData(collection: .profile)
    }
    
    private func setViewModel(urlString: String, name: String) {
        self.viewModel = TeamProfileViewModel(team: name, urlString: urlString)
    }
    
    private func showErrorAlert(error: String) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.documentErrorTitle, message:
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

//MARK: DatabaseManagerDelegate
extension TeamProfilePresenter: DatabaseManagerDelegate {
    
    func newData(_ data: [String: Any]?) {
        // Pull url and name out of the data retrieved
        let url = data?[Constants.UserDataModel.imageURL] as! String
        let name = data?[Constants.UserDataModel.teamName] as! String
        
        // Set a new view model with the new data
        setViewModel(urlString: url, name: name)
    }
    
    func displayError(with error: Error) {
        self.showErrorAlert(error: error.localizedDescription)
    }
}
