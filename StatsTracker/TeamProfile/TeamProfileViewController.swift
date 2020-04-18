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
    var viewModel: TeamProfileViewModel?
//    {
//        didSet {
//            fillUI()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add settings button
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(self.settingsPressed))
        self.navigationItem.rightBarButtonItem  = settingsButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillUI()
    }
    
    fileprivate func fillUI() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
        
        // We are sure here that we have all the setup done
        viewModel.teamName.bindAndFire { [unowned self] in self.teamNameLabel.text = $0 }
    }
    
    //MARK: Actions
    @objc func settingsPressed() {
        delegate?.settingsPressed()
    }
}

