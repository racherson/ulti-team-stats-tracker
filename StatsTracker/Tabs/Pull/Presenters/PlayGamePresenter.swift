//
//  PlayGamePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/21/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGamePresenterDelegate: AnyObject {
    func startPoint(vm: CallLineCellViewModel)
    func endGame()
}

class PlayGamePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: PlayGamePresenterDelegate?
    weak var vc: PlayGameViewController!
    var gameModel: GameDataModel
    var dbManager: DatabaseManager
    
    //MARK: Initialization
    init(vc: PlayGameViewController, delegate: PlayGamePresenterDelegate?, gameModel: GameDataModel, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.gameModel = gameModel
        self.dbManager = dbManager
        self.dbManager.getDataDelegate = self
        self.dbManager.setDataDelegate = self
        
        setViewModel()
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
    
    private func setViewModel() {
        // Get models from db, delegate function sets array
        dbManager.getData(collection: .roster)
    }
}

//MARK: PlayGamePresenterProtocol
extension PlayGamePresenter: PlayGamePresenterProtocol {
    // TODO
}

//MARK: DatabaseManagerGetDataDelegate
extension PlayGamePresenter: DatabaseManagerGetDataDelegate {

    func  displayError(with error: Error) {
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
        let selectedArray: [PlayerModel] = [PlayerModel]()
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

        let playerModels = [selectedArray, womenArray, menArray]
        
        let vm = CallLineCellViewModel(playerArray: playerModels, delegate: self)
        delegate?.startPoint(vm: vm)
    }
}

//MARK: DatabaseManagerSetDataDelegate
extension PlayGamePresenter: DatabaseManagerSetDataDelegate {
    func onSuccessfulSet() { }
}

//MARK: CallLineCellViewModelDelegate
extension PlayGamePresenter: CallLineCellViewModelDelegate {
    
    func endGame(items: [[PlayerViewModel]]) {
        // Save updated player models
        for array in items {
            for player in array {
                dbManager.setData(data: player.model.dictionary, collection: .roster)
            }
        }
        
        // Save game model
        dbManager.setData(data: gameModel.dictionary, collection: .games)
        
        delegate?.endGame()
    }
}
