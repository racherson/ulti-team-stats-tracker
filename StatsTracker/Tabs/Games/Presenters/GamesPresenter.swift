//
//  GamesPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol GamesPresenterDelegate: AnyObject {
    func goToGamePage(viewModel: GameViewModel)
}

class GamesPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: GamesPresenterDelegate?
    weak var vc: GamesViewController!
    var dbManager: DatabaseManager
    var tournamentModels: [[GameDataModel]]!
    
    //MARK: Initialization
    init(vc: GamesViewController, delegate: GamesPresenterDelegate?, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.dbManager = dbManager
        self.dbManager.getDataDelegate = self
        
        setTournamentArrays()
    }
    
    func onViewWillAppear() {
        vc.navigationItem.title = Constants.Titles.gamesTitle
    }
    
    //MARK: Private methods
    private func showErrorAlert(error: String) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.documentErrorTitle, message:
            error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Alerts.dismiss, style: .default))
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    private func getViewModel(model: GameDataModel) -> GameViewModel {
        return GameViewModel(model: model)
    }
    
    private func checkValidIndexPath(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        
        // Check if section in bounds
        if section < 0 || section >= tournamentModels.count {
            return false
        }
        
        // Check if row in bounds given the section
        if row < 0 || row >= tournamentModels[section].count {
            return false
        }
        
        return true
    }
}

//MARK: GamesPresenterProtocol
extension GamesPresenter: GamesPresenterProtocol {
    
    func setTournamentArrays() {
        // Get models from db, delegate function sets array
        dbManager.getData(collection: .games)
    }
    
    func numberOfTournaments() -> Int {
        return tournamentModels.count
    }
    
    func numberOfGamesInSection(_ section: Int) -> Int {
        if section < 0 || section >= tournamentModels.count {
            return Constants.Empty.int
        }
        return tournamentModels[section].count
    }
    
    func getGameOpponent(at indexPath: IndexPath) -> String {
        if checkValidIndexPath(indexPath) {
            return tournamentModels[indexPath.section][indexPath.row].opponent
        }
        return Constants.Empty.string
    }
    
    func getTournament(at indexPath: IndexPath) -> String {
        if checkValidIndexPath(indexPath) {
            return tournamentModels[indexPath.section][indexPath.row].tournament
        }
        return Constants.Empty.string
    }
    
    func goToGamePage(at indexPath: IndexPath) {
        if checkValidIndexPath(indexPath) {
            let model = tournamentModels[indexPath.section][indexPath.row]
            
            // Create a view model with the data model
            let viewModel = getViewModel(model: model)
            
            delegate?.goToGamePage(viewModel: viewModel)
        }
        else {
            displayError(with: CustomError.outOfBounds)
        }
    }
}

//MARK: DatabaseManagerGetDataDelegate
extension GamesPresenter: DatabaseManagerGetDataDelegate {
    func displayError(with error: Error) {
        // Empty model array
        if tournamentModels == nil {
            tournamentModels = []
        }
        self.showErrorAlert(error: error.localizedDescription)
    }
    
    func onSuccessfulGet(_ data: [String : Any]) {
        tournamentModels = []
        
        // Pull game out of the data retrieved
        guard let dataArray = data[FirebaseKeys.CollectionPath.games] as? [[String: Any]] else {
            self.showErrorAlert(error: Constants.Errors.documentError); return
        }
        
        // Initialize dictionary of tournament to game array
        var tournamentDict = [String: [GameDataModel]]()
        
        for data in dataArray {
            if let model = GameDataModel(documentData: data) {
                if tournamentDict[model.tournament] != nil {
                    tournamentDict[model.tournament]!.append(model)
                } else {
                    tournamentDict[model.tournament] = [model]
                }
            }
        }
        
        // Change dictionary to array
        for (_, val) in tournamentDict {
            tournamentModels.append(val)
        }
        
        vc.updateView()
    }
}
