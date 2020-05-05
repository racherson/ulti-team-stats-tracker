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
}

class RosterPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: RosterPresenterDelegate?
    weak var vc: RosterViewController!
    
    //MARK: Initialization
    init(vc: RosterViewController, delegate: RosterPresenterDelegate?) {
        self.vc = vc
        self.delegate = delegate
    }
}

extension RosterPresenter: RosterPresenterProtocol {
    
    func onViewWillAppear() {
        vc.navigationItem.title = Constants.Titles.rosterTitle
    }
    
    func addPressed() {
        delegate?.addPressed()
    }
}
