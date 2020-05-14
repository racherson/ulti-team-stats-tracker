//
//  PullViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PullPresenterProtocol where Self: Presenter { }

class PullViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: PullPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
}
