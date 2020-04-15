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
        var teamName: String?
        
        if let uid = Auth.auth().currentUser?.uid {
            FirestoreReferenceManager.referenceForUserPublicData(uid: uid).addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                teamName = document.get(FirebaseKeys.Field.teamName) as? String
                self.teamNameLabel.text = teamName ?? "Team Name"
            }
        }
    }
    
    //MARK: Actions
    @objc func settingsPressed() {
        delegate?.settingsPressed()
    }
    
}

