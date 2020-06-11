//
//  GameDetailPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol GameDetailPresenterDelegate: AnyObject { }

class GameDetailPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: GameDetailPresenterDelegate?
    weak var vc: GameDetailViewController!
    let viewModel: GameViewModel
    
    //MARK: Initialization
    init(vc: GameDetailViewController, delegate: GameDetailPresenterDelegate?, viewModel: GameViewModel) {
        self.vc = vc
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    func onViewWillAppear() {
        vc.navigationItem.title = viewModel.opponent
        vc.updateWithViewModel(vm: viewModel)
    }
}

//MARK: GameDetailPresenterProtocol
extension GameDetailPresenter: GameDetailPresenterProtocol { }
