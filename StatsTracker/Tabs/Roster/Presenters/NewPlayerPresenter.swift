//
//  NewPlayerPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol NewPlayerPresenterDelegate: AnyObject {
    func cancelPressed()
    func savePressed(player: PlayerModel)
}

class NewPlayerPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: NewPlayerPresenterDelegate?
    weak var vc: NewPlayerViewController!
    
    //MARK: Initialization
    init(vc: NewPlayerViewController, delegate: NewPlayerPresenterDelegate?) {
        self.vc = vc
        self.delegate = delegate
    }
}

//MARK: NewPlayerPresenterProtocol
extension NewPlayerPresenter: NewPlayerPresenterProtocol {
    
    func onViewWillAppear() {
        vc.navigationItem.title = Constants.Titles.newPlayerTitle
    }
    
    func cancelPressed() {
        delegate?.cancelPressed()
    }
    
    func savePressed(model: PlayerModel) {
        //TODO: Try to update db
        // if error, display error, else call delegate
        
        delegate?.savePressed(player: model)
    }
}
