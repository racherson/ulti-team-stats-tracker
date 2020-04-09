//
//  RosterViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class RosterViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    weak var coordinator: RosterCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: Actions
    @IBAction func createAccount(_ sender: UIButton) {
        coordinator?.createAccount()
    }
    
    @IBAction func buyTapped(_ sender: UIButton) {
        coordinator?.buySubscription()
    }
}
