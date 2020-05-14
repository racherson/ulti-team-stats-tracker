//
//  GamesPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol GamesPresenterDelegate: AnyObject { }

class GamesPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: GamesPresenterDelegate?
    weak var vc: GamesViewController!
    
    //MARK: Initialization
    init(vc: GamesViewController, delegate: GamesPresenterDelegate?) {
        self.vc = vc
        self.delegate = delegate
    }
    
    func onViewWillAppear() {
        vc.navigationItem.title = Constants.Titles.gamesTitle
    }
}

//MARK: GamesPresenterProtocol
extension GamesPresenter: GamesPresenterProtocol { }
