//
//  PlayGamePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol PlayGamePresenterDelegate: AnyObject { }

class PlayGamePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: PlayGamePresenterDelegate?
    weak var vc: PlayGameViewController!
    
    //MARK: Initialization
    init(vc: PlayGameViewController, delegate: PlayGamePresenterDelegate?) {
        self.vc = vc
        self.delegate = delegate
    }
    
    func onViewWillAppear() {
        //
    }
}

//MARK: PlayGamePresenterProtocol
extension PlayGamePresenter: PlayGamePresenterProtocol { }
