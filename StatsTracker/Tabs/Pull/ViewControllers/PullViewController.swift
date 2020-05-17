//
//  PullViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PullPresenterProtocol where Self: Presenter {
    func startGamePressed()
}

class PullViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: PullPresenterProtocol!
    @IBOutlet weak var tournamentTextField: UITextField!
    @IBOutlet weak var opponentTextField: UITextField!
    @IBOutlet weak var offenseSegmentedControl: UISegmentedControl!
    @IBOutlet weak var windSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    //MARK: Actions
    @IBAction func startGamePressed(_ sender: UIButton) {
        presenter.startGamePressed()
    }
}
