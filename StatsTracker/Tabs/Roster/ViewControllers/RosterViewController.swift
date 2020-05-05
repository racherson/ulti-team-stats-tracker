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

protocol RosterPresenterProtocol where Self: Presenter {
    func onViewWillAppear()
    func addPressed()
}

class RosterViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: RosterPresenterProtocol!
    @IBOutlet weak var tableView: UITableView!
    let names = [
        ["Rachel", "Corinne"],
        ["Kenneth", "George"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the size of the tableview
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Connect tableView to the View Controller
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add pluse button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addPressed))
        self.navigationItem.rightBarButtonItem  = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    //MARK: Actions
    @objc func addPressed() {
        presenter.addPressed()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension RosterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names[section].count
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
        cell.textLabel?.text = names[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Set action on selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
