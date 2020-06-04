//
//  PlayGamePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGamePresenterDelegate: AnyObject {
    func endGame()
}

class PlayGamePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: PlayGamePresenterDelegate?
    weak var vc: PlayGameViewController!
    var gameModel: GameDataModel
    var dbManager: DatabaseManager
    var playerModels: [[PlayerModel]]?
    var currentPointWind: WindDirection!
    var currentPointType: PointType!
    let selectedPlayerSection = 0
    
    //MARK: Initialization
    init(vc: PlayGameViewController, delegate: PlayGamePresenterDelegate?, gameModel: GameDataModel, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.gameModel = gameModel
        self.dbManager = dbManager
        self.dbManager.getDataDelegate = self
        
        fetchRoster()
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
    
    private func fetchRoster() {
        // Get models from db, delegate function sets array
        dbManager.getData(collection: .roster)
    }
    
    private func checkValidIndexPath(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        
        guard let playerModels = playerModels else {
            // playerModels is nil
            return false
        }
        
        // Check if section in bounds
        if section < 0 || section >= playerModels.count {
            return false
        }
        
        // Check if row in bounds given the section
        if row < 0 || row >= playerModels[section].count {
            return false
        }
        
        return true
    }
    
    private func fullLine() -> Bool {
        guard let playerModels = playerModels else {
            return false
        }
        // Check if selected array has 7 players
        return playerModels[selectedPlayerSection].count < Constants.fullLine ? false : true
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
        guard let models = playerModels else {
            fatalError("Unable to retrieve players")
        }
        
        // Add players back to their gender arrays
        for player in models[selectedPlayerSection] {
            playerModels![player.gender + 1].append(player)
        }
        
        // Remove all players from selected array
        playerModels![selectedPlayerSection].removeAll()
        vc.updateView()
    }
    
    private func confirmedStartPoint() {
        // TODO: Give the selected players to the next step
        // Hide player selection UI and display point UI
        vc.showPlayPoint()
    }
}

//MARK: PlayGamePresenterProtocol
extension PlayGamePresenter: PlayGamePresenterProtocol {
    
    func startPoint() {
        if !fullLine() {
            displayConfirmAlert()
        }
        else {
            confirmedStartPoint()
        }
    }
    
    func nextPoint(scored: Bool) {
        // Give current point to game model
        let point = PointDataModel(wind: currentPointWind, scored: scored, type: currentPointType)
        gameModel.addPoint(point: point)
        // TODO: Update wind and point type
        
        // Clear old line
        clearLine()
        // Hide play point UI and display call line UI
        vc.showCallLine()
    }
    
    func numberOfPlayersInSection(_ section: Int) -> Int {
        guard let models = playerModels else {
            return Constants.Empty.int
        }
        // Check if section is in bounds
        return section < 0 || section >= models.count ? Constants.Empty.int : models[section].count
    }
    
    func getPlayerName(at indexPath: IndexPath) -> String {
        
        if checkValidIndexPath(indexPath) {
            // playerModels is verified in checkValidIndexPath
            return playerModels![indexPath.section][indexPath.row].name
        }
        return Constants.Empty.string
    }
    
    func selectPlayer(at indexPath: IndexPath) -> IndexPath? {
        guard let models = playerModels else {
            fatalError("Unable to retrieve players")
        }
        
        // Get player model
        let player = models[indexPath.section][indexPath.row]
        // Get the section to move player to, based on if they are already selected or not
        let section = indexPath.section == selectedPlayerSection ? player.gender + 1 : selectedPlayerSection
        
        // Don't select more than 7 players
        if section == selectedPlayerSection && models[selectedPlayerSection].count >= Constants.fullLine {
            return nil
        }
        
        // Add to selected array
        playerModels![section].append(player)
        // Remove from gender array
        playerModels![indexPath.section].remove(at: indexPath.row)
        
        return IndexPath(row: playerModels![section].count - 1, section: section)
    }
    
    func endGame() {
        // TODO: Save game data to Firestore
        
        let completionAlert = UIAlertController(title: Constants.Alerts.endGameTitle, message: Constants.Alerts.successfulRecordAlert, preferredStyle: UIAlertController.Style.alert)

        // Confirm action and end game
        completionAlert.addAction(UIAlertAction(title: Constants.Alerts.okay, style: .default, handler: { (action: UIAlertAction!) in self.delegate?.endGame() }))

        vc.present(completionAlert, animated: true, completion: nil)
    }
}

//MARK: DatabaseManagerGetDataDelegate
extension PlayGamePresenter: DatabaseManagerGetDataDelegate {

    func  displayError(with error: Error) {
        // Empty model array
        if playerModels == nil {
            playerModels = [ [], [], [] ]
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

        playerModels = [selectedArray, womenArray, menArray]
        vc.updateView()
    }
}
