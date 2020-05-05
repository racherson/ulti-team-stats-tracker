//
//  RosterViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

enum Sections: Int, CaseIterable {
    case women
    case men
}

class RosterViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: RosterPresenter!
    @IBOutlet weak var tableView: UITableView!
    let names = ["hi", "another", "more", "blah", "pizza"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.Titles.rosterTitle
        
        // Setup the size of the tableview
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Connect tableView to the View Controller
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension RosterViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Sections.women.rawValue:
            return Constants.Titles.women
        case Sections.men.rawValue:
            return Constants.Titles.men
        default:
            fatalError(Constants.Errors.rosterCellError)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RosterTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RosterTableViewCell else {
            fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        // Configure the cell
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}
