//
//  GameDetailViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol GameDetailPresenterProtocol where Self: Presenter { }

class GameDetailViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: GameDetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateWithViewModel(vm: GameViewModel) {
        // TODO
    }
}
