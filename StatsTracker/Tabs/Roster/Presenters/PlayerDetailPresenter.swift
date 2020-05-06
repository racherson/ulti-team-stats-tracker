//
//  PlayerDetailPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol PlayerDetailPresenterDelegate: AnyObject {
}

class PlayerDetailPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: PlayerDetailPresenterDelegate?
    weak var vc: PlayerDetailViewController!
    let viewModel: PlayerViewModel
    
    //MARK: Initialization
    init(vc: PlayerDetailViewController, delegate: PlayerDetailPresenterDelegate?, viewModel: PlayerViewModel) {
        self.vc = vc
        self.delegate = delegate
        self.viewModel = viewModel
    }
}

extension PlayerDetailPresenter: PlayerDetailPresenterProtocol {
    func onViewWillAppear() {
        vc.navigationItem.title = viewModel.name
    }
}
