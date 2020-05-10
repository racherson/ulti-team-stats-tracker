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
    var playerModels: [[PlayerModel]]!
    
    //MARK: Initialization
    init(vc: RosterViewController, delegate: RosterPresenterDelegate?, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.dbManager = dbManager
        self.dbManager.delegate = self
        
        setGenderArrays()
    }
    
    //MARK: Private methods
    private func showErrorAlert(error: String) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.documentErrorTitle, message:
            error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Alerts.dismiss, style: .default))

        vc.present(alertController, animated: true, completion: nil)
    }
    
    private func setGenderArrays() {
        // Get models from db, delegate function sets array
        dbManager.getData(collection: .roster)
    }
    
    private func getViewModel(model: PlayerModel) -> PlayerViewModel {
        return PlayerViewModel(model: model)
    }
}

//MARK: RosterPresenterProtocol
extension RosterPresenter: RosterPresenterProtocol {
    
    func onViewWillAppear() {
        vc.navigationItem.title = Constants.Titles.rosterTitle
    }
    
    func numberOfPlayersInSection(_ section: Int) -> Int {
        return playerModels[section].count
    }
    
    func getPlayerName(at indexPath: IndexPath) -> String {
        return playerModels[indexPath.section][indexPath.row].name
    }
    
    func addPressed() {
        delegate?.addPressed()
    }
    
    func addPlayer(_ player: PlayerModel) {
        // Update player array
        playerModels[player.gender].append(player)
        
        vc.updateView()
    }
    
    func goToPlayerPage(at indexPath: IndexPath) {
        let model = playerModels[indexPath.section][indexPath.row]

        // Create a view model with the data model
        let viewModel = getViewModel(model: model)
        
        delegate?.goToPlayerPage(viewModel: viewModel)
    }
    
    func deletePlayer(at indexPath: IndexPath) {
        
        // Delete from database
        let modelToDelete = playerModels[indexPath.section][indexPath.row]
        dbManager.deleteData(data: modelToDelete.dictionary, collection: .roster)
        
        // Update player array
        playerModels[indexPath.section].remove(at: indexPath.row)
        
        vc.updateView()
    }
}

//MARK: DatabaseManagerDelegate
extension RosterPresenter: DatabaseManagerDelegate {
    
    func  displayError(with error: Error) {
        // Empty model array
        playerModels = [ [], [] ]
        self.showErrorAlert(error: error.localizedDescription)
    }
    
    func newData(_ data: [String : Any]?) {
        guard let data = data else {
            // Empty model array
            playerModels = [ [], [] ]
            self.showErrorAlert(error: Constants.Errors.documentError)
            return
        }
        
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
    }
}
