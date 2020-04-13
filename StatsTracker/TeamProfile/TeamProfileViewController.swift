//
//  TeamProfileViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol TeamProfileViewControllerDelegate {
    func settingsPressed()
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
    
    //MARK: Actions
    @objc func settingsPressed() {
        delegate?.settingsPressed()
    }
    
}

