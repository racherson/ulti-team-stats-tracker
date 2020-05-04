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
    weak var delegate: RosterCoordinator?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        // Connect tableView to the View Controller
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func updateViewConstraints() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        super.updateViewConstraints()
    }

}

extension RosterViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RosterTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RosterTableViewCell else {
            fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        // Configure the cell
//        cell.setup(type: indexPath.row)
        return cell
    }
}
