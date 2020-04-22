//
//  TeamProfileViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol TeamProfilePresenterProtocol {
    func onViewWillAppear()
    func settingsPressed()
}

class TeamProfileViewController: UIViewController, Storyboarded {

    //MARK: Properties
    var presenter: TeamProfilePresenter!
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
        presenter.onViewWillAppear()
    }
    
    func updateWithViewModel(vm: TeamProfileViewModel) {
        if !isViewLoaded {
            return
        }
        teamNameLabel.text = vm.teamName
        teamImage.image = vm.teamImage
    }
    
    //MARK: Actions
    @objc func settingsPressed() {
        presenter.settingsPressed()
    }
}
