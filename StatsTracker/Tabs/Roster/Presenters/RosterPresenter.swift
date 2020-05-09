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
    var viewModel: RosterViewModel
    var dbManager: DatabaseManager!
    
    //MARK: Initialization
    init(vc: RosterViewController, delegate: RosterPresenterDelegate?, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.viewModel = RosterViewModel()
        self.vc.viewModel = viewModel
        self.dbManager = dbManager
        self.dbManager.delegate = self
    }
}

extension RosterPresenter: RosterPresenterProtocol {
    
    func onViewWillAppear() {
        vc.navigationItem.title = Constants.Titles.rosterTitle
    }
    
    func addPressed() {
        delegate?.addPressed()
    }
    
    func addPlayer(_ player: PlayerViewModel) {
        // Update view model
        viewModel.cellViewModels[player.gender.rawValue].append(player)
        
        //TODO: Save new data to db
        
        vc.updateWithViewModel(viewModel: viewModel)
    }
    
    func goToPlayerPage(viewModel: PlayerViewModel) {
        delegate?.goToPlayerPage(viewModel: viewModel)
    }
    
    func deletePlayer(at indexPath: IndexPath) {
        // Update view model
        viewModel.cellViewModels[indexPath.section].remove(at: indexPath.row)
        vc.updateWithViewModel(viewModel: viewModel)
        
        //TODO: Save new data to db
    }
}

extension RosterPresenter: DatabaseManagerDelegate {
    func  displayError(with error: Error) {
        //TODO
    }
}
