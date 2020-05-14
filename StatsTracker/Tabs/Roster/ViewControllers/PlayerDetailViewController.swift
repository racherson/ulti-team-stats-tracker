//
//  PlayerDetailViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayerDetailPresenterProtocol where Self: Presenter { }

class PlayerDetailViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: PlayerDetailPresenterProtocol!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var pointsPlayedLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var dLabel: UILabel!
    @IBOutlet weak var completionsLabel: UILabel!
    @IBOutlet weak var throwawaysLabel: UILabel!
    @IBOutlet weak var completionPercentLabel: UILabel!
    @IBOutlet weak var catchesLabel: UILabel!
    @IBOutlet weak var dropsLabel: UILabel!
    @IBOutlet weak var catchPercentLabel: UILabel!
    @IBOutlet weak var pullsLabel: UILabel!
    @IBOutlet weak var callahanLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateWithViewModel(vm: PlayerViewModel) {
        gamesPlayedLabel.text = vm.games
        pointsPlayedLabel.text = vm.points
        goalsLabel.text = vm.goals
        assistsLabel.text = vm.assists
        dLabel.text = vm.ds
        completionsLabel.text = vm.completions
        throwawaysLabel.text = vm.throwaways
        completionPercentLabel.text = vm.completionPercentage
        catchesLabel.text = vm.catches
        dropsLabel.text = vm.drops
        catchPercentLabel.text = vm.catchingPercentage
        pullsLabel.text = vm.pulls
        callahanLabel.text = vm.callahans
    }
}
