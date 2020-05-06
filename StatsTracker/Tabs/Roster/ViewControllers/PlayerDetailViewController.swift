//
//  PlayerDetailViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayerDetailPresenterProtocol {
    func onViewWillAppear()
}

class PlayerDetailViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: PlayerDetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
}
