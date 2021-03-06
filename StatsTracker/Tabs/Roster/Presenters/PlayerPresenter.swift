//
//  NewPlayerPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol PlayerPresenterDelegate: AnyObject {
    func cancelPressed()
    func savePressed(player: PlayerViewModel)
}

class NewPlayerPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: PlayerPresenterDelegate?
    weak var vc: NewPlayerViewController!
    
    //MARK: Initialization
    init(vc: NewPlayerViewController, delegate: PlayerPresenterDelegate?) {
        self.vc = vc
        self.delegate = delegate
    }
}

extension NewPlayerPresenter: PlayerPresenterProtocol {
    
    func onViewWillAppear() {
    }
    
    func cancelPressed() {
        delegate?.cancelPressed()
    }
    
    func savePressed(vm: PlayerViewModel) {
        delegate?.savePressed(player: vm)
    }
}
