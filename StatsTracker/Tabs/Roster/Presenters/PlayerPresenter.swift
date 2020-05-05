//
//  PlayerPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol PlayerPresenterDelegate: AnyObject {
    func cancelPressed()
    func savePressed()
}

class PlayerPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: PlayerPresenterDelegate?
    weak var vc: PlayerViewController!
    
    //MARK: Initialization
    init(vc: PlayerViewController, delegate: PlayerPresenterDelegate?) {
        self.vc = vc
        self.delegate = delegate
    }
}

extension PlayerPresenter: PlayerPresenterProtocol {
    
    func onViewWillAppear() {
    }
    
    func cancelPressed() {
        delegate?.cancelPressed()
    }
    
    func savePressed() {
        delegate?.savePressed()
    }
}
