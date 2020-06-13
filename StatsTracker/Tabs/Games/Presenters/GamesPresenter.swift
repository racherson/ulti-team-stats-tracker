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
    
    //MARK: Initialization
    init(vc: GamesViewController, delegate: GamesPresenterDelegate?, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.dbManager = dbManager
        self.dbManager.getDataDelegate = self
        
        setViewModel()
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
}

//MARK: GamesPresenterProtocol
extension GamesPresenter: GamesPresenterProtocol {
    func setViewModel() {
        // Get models from db, delegate function sets array
        dbManager.getData(collection: .games)
    }
}

//MARK: GamesCellViewModelDelegate
extension GamesPresenter: GamesCellViewModelDelegate {
    func goToGamePage(viewModel: GameViewModel) {
        delegate?.goToGamePage(viewModel: viewModel)
    }
    
    func updateView() {
        vc.updateView()
    }
}

//MARK: DatabaseManagerGetDataDelegate
extension GamesPresenter: DatabaseManagerGetDataDelegate {
    func displayError(with error: Error) {
        // Empty model array
        if vc.viewModel == nil {
            vc.viewModel = GamesCellViewModel(gameArray: [], delegate: self)
        }
        self.showErrorAlert(error: error.localizedDescription)
    }
    
    func onSuccessfulGet(_ data: [String : Any]) {
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
        
        var tournamentArray = [[GameDataModel]]()
        // Change dictionary to array
        for (_, val) in tournamentDict {
            tournamentArray.append(val)
        }
        
        vc.updateWithViewModel(vm: GamesCellViewModel(gameArray: tournamentArray, delegate: self))
    }
}
