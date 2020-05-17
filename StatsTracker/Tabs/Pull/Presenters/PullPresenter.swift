//
//  PullPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol PullPresenterDelegate: AnyObject {
    func startGamePressed()
}

class PullPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: PullPresenterDelegate?
    weak var vc: PullViewController!
    
    //MARK: Initialization
    init(vc: PullViewController, delegate: PullPresenterDelegate?) {
        self.vc = vc
        self.delegate = delegate
    }
    
    func onViewWillAppear() {
        vc.navigationItem.title = Constants.Titles.pullTitle
    }
}

//MARK: PullPresenterProtocol
extension PullPresenter: PullPresenterProtocol {
    func startGamePressed() {
        delegate?.startGamePressed()
    }
}
