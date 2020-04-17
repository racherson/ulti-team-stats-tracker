//
//  TeamProfileViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol TeamProfileViewControllerDelegate {
    func settingsPressed()
    func onViewWillAppear()
}

class TeamProfileViewController: UIViewController, Storyboarded {

    //MARK: Properties
    var delegate: TeamProfileViewControllerDelegate?
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add settings button
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(self.settingsPressed))
        self.navigationItem.rightBarButtonItem  = settingsButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onViewWillAppear()
    }
    
    func updateWithViewModel(vm: TeamProfileViewModel) {
        // Set label with team name from view model
        teamNameLabel.text = vm.teamName
    }
    
    //MARK: Actions
    @objc func settingsPressed() {
        delegate?.settingsPressed()
    }
}

