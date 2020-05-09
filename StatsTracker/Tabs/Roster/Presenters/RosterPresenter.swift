//
//  RosterPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol RosterPresenterDelegate: AnyObject {
    func addPressed()
    func goToPlayerPage(viewModel: PlayerViewModel)
}

class RosterPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: RosterPresenterDelegate?
    weak var vc: RosterViewController!
    var dbManager: DatabaseManager!
    var playerModels: [[PlayerModel]]!
    
    //MARK: Initialization
    init(vc: RosterViewController, delegate: RosterPresenterDelegate?, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.dbManager = dbManager
        self.dbManager.delegate = self
        
        setGenderArrays()
    }
    
    func setGenderArrays() {
        //TODO: Get models from db
        
        playerModels = [
            [], // Array of women
            [] // Array of men
        ]
    }
    
    func getViewModel(model: PlayerModel) -> PlayerViewModel {
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
        //TODO: Try to save new data to db
        
        // Update player array
        playerModels[indexPath.section].remove(at: indexPath.row)
        
        vc.updateView()
    }
}

//MARK: DatabaseManagerDelegate
extension RosterPresenter: DatabaseManagerDelegate {
    func  displayError(with error: Error) {
        //TODO
    }
}
