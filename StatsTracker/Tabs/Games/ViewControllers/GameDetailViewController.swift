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
    @IBOutlet weak var tournamentLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var breaksLabel: UILabel!
    @IBOutlet weak var breaksAgainstLabel: UILabel!
    @IBOutlet weak var offensiveEfficiencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Color.setGradient(view: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateWithViewModel(vm: GameViewModel) {
        tournamentLabel.text = vm.tournament
        scoreLabel.text = vm.finalScore
        breaksLabel.text = vm.breaksFor
        breaksAgainstLabel.text = vm.breaksAgainst
        offensiveEfficiencyLabel.text = vm.offensiveEfficiency
    }
}
