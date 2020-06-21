//
//  CallLinePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol CallLinePresenterDelegate: AnyObject {
    func endGame()
}

class CallLinePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: CallLinePresenterDelegate?
    weak var vc: CallLineViewController!
    var gameModel: GameDataModel
    var dbManager: DatabaseManager
    var currentPointWind: WindDirection!
    var currentPointType: PointType!
    
    //MARK: Initialization
    init(vc: CallLineViewController, delegate: CallLinePresenterDelegate?, gameModel: GameDataModel, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.gameModel = gameModel
        self.dbManager = dbManager
        self.dbManager.getDataDelegate = self
        self.dbManager.setDataDelegate = self
        
        setViewModel()
    }
    
    func onViewWillAppear() {
        vc.showCallLine()
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
    
    private func displayConfirmAlert() {
        let confirmationAlert = UIAlertController(title: Constants.Alerts.startGameTitle, message: Constants.Alerts.startGameAlert, preferredStyle: UIAlertController.Style.alert)
        
        // Cancel action and dismiss
        confirmationAlert.addAction(UIAlertAction(title: Constants.Alerts.cancel, style: .destructive, handler: { (action: UIAlertAction!) in confirmationAlert.dismiss(animated: true, completion: nil) }))

        // Confirm action and start point
        confirmationAlert.addAction(UIAlertAction(title: Constants.Alerts.confirm, style: .default, handler: { (action: UIAlertAction!) in self.confirmedStartPoint() }))

        vc.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func clearLine() {
        vc.clearLine()
    }
    
    private func confirmedStartPoint() {
        // Hide player selection UI and display point UI
        vc.showPlayPoint()
    }
    
    private func updateWind() {
        switch currentPointWind {
        case .upwind:
            currentPointWind = .downwind
        case .downwind:
            currentPointWind = .upwind
        case .crosswind:
            currentPointWind = .crosswind
        case .none:
            return
        }
    }
    
    private func updatePointType(scored: Bool) {
        // The team that scores pulls the next point (starts on defense)
        if scored {
            currentPointType = .defensive
        }
        else {
            currentPointType = .offensive
        }
    }
}

//MARK: CallLinePresenterProtocol
extension CallLinePresenter: CallLinePresenterProtocol {
    
    func startPoint() {
        if !vc.fullLine() {
            displayConfirmAlert()
        }
        else {
            confirmedStartPoint()
        }
    }
    
    func nextPoint(scored: Bool) {
        // Give current point to game model
        // TODO: fix use of wind and type enums...do we need them? or just use int
        let point = PointDataModel(wind: currentPointWind.rawValue, scored: scored, type: currentPointType.rawValue)
        gameModel.addPoint(point: point)
        
        // Update game state
        updateWind()
        updatePointType(scored: point.scored)
        clearLine()
        
        // Hide play point UI and display call line UI
        vc.showCallLine()
    }
}

//MARK: DatabaseManagerGetDataDelegate
extension CallLinePresenter: DatabaseManagerGetDataDelegate {

    func  displayError(with error: Error) {
        // Empty model array
        if vc.viewModel == nil {
            vc.viewModel = PlayerCollectionViewCellViewModel(playerArray: [[], [], []], delegate: self)
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
        
        let vm = PlayerCollectionViewCellViewModel(playerArray: playerModels, delegate: self)
        vc.updateWithViewModel(vm: vm)
    }
}

//MARK: DatabaseManagerSetDataDelegate
extension CallLinePresenter: DatabaseManagerSetDataDelegate {
    func onSuccessfulSet() { }
}

//MARK: PlayerCollectionViewCellViewModelDelegate
extension CallLinePresenter: PlayerCollectionViewCellViewModelDelegate {
    
    func endGame(items: [[PlayerViewModel]]) {
        // Save updated player models
        for array in items {
            for player in array {
                dbManager.setData(data: player.model.dictionary, collection: .roster)
            }
        }
        
        // Save game model
        dbManager.setData(data: gameModel.dictionary, collection: .games)
        
        let completionAlert = UIAlertController(title: Constants.Alerts.endGameTitle, message: Constants.Alerts.successfulRecordAlert, preferredStyle: UIAlertController.Style.alert)

        // Confirm action and end game
        completionAlert.addAction(UIAlertAction(title: Constants.Alerts.okay, style: .default, handler: { (action: UIAlertAction!) in self.delegate?.endGame() }))

        vc.present(completionAlert, animated: true, completion: nil)
    }
}
