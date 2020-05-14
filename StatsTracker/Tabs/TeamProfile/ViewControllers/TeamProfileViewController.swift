//
//  TeamProfileViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol TeamProfilePresenterProtocol where Self: Presenter {
    var viewModel: TeamProfileViewModel? { get set }
    func settingsPressed()
}

class TeamProfileViewController: UIViewController, Storyboarded {

    //MARK: Properties
    var presenter: TeamProfilePresenterProtocol!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add settings button
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(self.settingsPressed))
        self.navigationItem.rightBarButtonItem  = settingsButton
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateWithViewModel(viewModel: TeamProfileViewModel) {
        if !isViewLoaded {
            return
        }
        
        // Check if currently loading
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            teamNameLabel.alpha = 1
            teamImage.alpha = 1
        }
        
        teamNameLabel.text = viewModel.teamName
        teamImage.image = viewModel.teamImage
    }
    
    func loadingState() {
        // Hide fields and start activity indicator
        teamNameLabel.alpha = 0
        teamImage.alpha = 0
        activityIndicator.startAnimating()
    }
    
    //MARK: Actions
    @objc func settingsPressed() {
        presenter.settingsPressed()
    }
}
