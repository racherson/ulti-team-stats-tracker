//
//  PlayGamePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGamePresenterDelegate: AnyObject { }

class PlayGamePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: PlayGamePresenterDelegate?
    weak var vc: PlayGameViewController!
    var dbManager: DatabaseManager
    var playerModels: [[PlayerModel]]?
    var selectedPlayerCount: Int = 0
    
    //MARK: Initialization
    init(vc: PlayGameViewController, delegate: PlayGamePresenterDelegate?, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.dbManager = dbManager
        self.dbManager.getDataDelegate = self
        
        fetchRoster()
    }
    
    func onViewWillAppear() {
        vc.navigationItem.title = Constants.Titles.pointTitle
    }
    
    //MARK: Private methods
    private func showErrorAlert(error: String) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.documentErrorTitle, message:
            error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Alerts.dismiss, style: .default))

        vc.present(alertController, animated: true, completion: nil)
    }
    
    private func fetchRoster() {
        // Get models from db, delegate function sets array
        dbManager.getData(collection: .roster)
    }
}

//MARK: PlayGamePresenterProtocol
extension PlayGamePresenter: PlayGamePresenterProtocol {
    
    func fullLine() -> Bool {
        return selectedPlayerCount < 7 ? false : true
    }
    
    func displayConfirmAlert() {
        let confirmationAlert = UIAlertController(title: Constants.Alerts.startGameTitle, message: Constants.Alerts.startGameAlert, preferredStyle: UIAlertController.Style.alert)
        
        // Cancel action and dismiss
        confirmationAlert.addAction(UIAlertAction(title: Constants.Alerts.cancel, style: .destructive, handler: { (action: UIAlertAction!) in confirmationAlert.dismiss(animated: true, completion: nil) }))

        // Confirm action and start point
        confirmationAlert.addAction(UIAlertAction(title: Constants.Alerts.confirm, style: .default, handler: { (action: UIAlertAction!) in self.startPoint() }))

        vc.present(confirmationAlert, animated: true, completion: nil)
    }
    
    func startPoint() {
        // Give the selected players to the next step
        // Hide player selection UI
        // Display point UI
    }
    
    func numberOfPlayersInSection(_ section: Int) -> Int {
        guard let models = playerModels else {
            return Constants.Empty.int
        }
        return section < 0 || section >= models.count ? Constants.Empty.int : models[section].count
    }
}

//MARK: DatabaseManagerGetDataDelegate
extension PlayGamePresenter: DatabaseManagerGetDataDelegate {

    func  displayError(with error: Error) {
        // Empty model array
        if playerModels == nil {
            playerModels = [ [], [] ]
        }
        self.showErrorAlert(error: error.localizedDescription)
    }
    
    func onSuccessfulGet(_ data: [String : Any]) {
        // Pull woman and man arrays out of the data retrieved
        guard let womenDataArray = data[FirebaseKeys.CollectionPath.women] as? [[String: Any]] else {
            self.showErrorAlert(error: Constants.Errors.documentError)
            return
        }
        guard let menDataArray = data[FirebaseKeys.CollectionPath.men] as? [[String: Any]] else {
            self.showErrorAlert(error: Constants.Errors.documentError)
            return
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

        playerModels = [womenArray, menArray]
        vc.updateView()
    }
}
