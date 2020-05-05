//
//  PlayerViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayerPresenterProtocol {
    func onViewWillAppear()
}

class PlayerViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: PlayerPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
}
