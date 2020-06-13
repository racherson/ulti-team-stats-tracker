//
//  RosterPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol RosterPresenterDelegate: AnyObject {
    func addPressed()
    func goToPlayerPage(viewModel: PlayerViewModel)
}

class RosterPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: RosterPresenterDelegate?
    weak var vc: RosterViewController!
    var dbManager: DatabaseManager
    
    //MARK: Initialization
    init(vc: RosterViewController, delegate: RosterPresenterDelegate?, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.dbManager = dbManager
        self.dbManager.getDataDelegate = self
        self.dbManager.deleteDataDelegate = self
        
        setViewModel()
    }
    
    func onViewWillAppear() {
        vc.navigationItem.title = Constants.Titles.rosterTitle
    }
    
    //MARK: Private methods
    private func showErrorAlert(error: String) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.documentErrorTitle, message:
            error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Alerts.dismiss, style: .default))

        vc.present(alertController, animated: true, completion: nil)
    }
}

//MARK: RosterPresenterProtocol
extension RosterPresenter: RosterPresenterProtocol {

    func setViewModel() {
        // Get models from db, delegate function sets view model
        dbManager.getData(collection: .roster)
    }
    
    func addPressed() {
        delegate?.addPressed()
    }
}

//MARK: RosterCellViewModelDelegate
extension RosterPresenter: RosterCellViewModelDelegate {
    
    func goToPlayerPage(viewModel: PlayerViewModel) {
        delegate?.goToPlayerPage(viewModel: viewModel)
    }
    
    func deletePlayer(_ player: PlayerModel) {
        // Delete from database
        dbManager.deleteData(data: player.dictionary, collection: .roster)
    }
    
    func updateView() {
        vc.updateView()
    }
    
}

//MARK: DatabaseManagerGetDataDelegate
extension RosterPresenter: DatabaseManagerGetDataDelegate {

    func  displayError(with error: Error) {
        // Empty model array
        if vc.viewModel == nil {
            vc.viewModel = RosterCellViewModel(playerArray: [[], []], delegate: self)
        }
        self.showErrorAlert(error: error.localizedDescription)
    }
    
    func onSuccessfulGet(_ data: [String : Any]) {
        // Pull woman and man arrays out of the data retrieved
        guard let womenDataArray = data[FirebaseKeys.CollectionPath.women] as? [[String: Any]] else {
            self.showErrorAlert(error: Constants.Errors.documentError); return
        }
        guard let menDataArray = data[FirebaseKeys.CollectionPath.men] as? [[String: Any]] else {
            self.showErrorAlert(error: Constants.Errors.documentError); return
        }
        
        // Initialize the new arrays of player models
        var womenArray: [PlayerModel] = [PlayerModel]()
        var menArray: [PlayerModel] = [PlayerModel]()
        
        for data in womenDataArray {
            if let model = PlayerModel(documentData: data) {
                womenArray.append(model)
            }
        }
        
        for data in menDataArray {
            if let model = PlayerModel(documentData: data) {
                menArray.append(model)
            }
        }

        vc.updateWithViewModel(vm: RosterCellViewModel(playerArray: [womenArray, menArray], delegate: self))
    }
}

extension RosterPresenter: DatabaseManagerDeleteDataDelegate {
    func onSuccessfulDelete() { }
}
