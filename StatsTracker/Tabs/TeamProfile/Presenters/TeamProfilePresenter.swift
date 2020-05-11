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
        self.dbManager.getDataDelegate = self
        
        initializeViewModel()
    }
    
    //MARK: Private methods
    private func initializeViewModel() {
        dbManager.getData(collection: .profile)
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

//MARK: DatabaseManagerGetDataDelegate
extension TeamProfilePresenter: DatabaseManagerGetDataDelegate {
    
    func displayError(with error: Error) {
        self.showErrorAlert(error: error.localizedDescription)
    }
    
    func onSuccessfulGet(_ data: [String : Any]) {
        let defaultModel = UserDataModel(teamName: Constants.Empty.teamName, email: Constants.Empty.email, imageURL: Constants.Empty.string)
        let dataModel = UserDataModel(documentData: data)
        let model = dataModel != nil ? dataModel! : defaultModel
        
        self.viewModel = TeamProfileViewModel(model: model)
    }
}
