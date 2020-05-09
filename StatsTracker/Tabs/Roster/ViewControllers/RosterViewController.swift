//
//  RosterViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

enum Gender: Int, CaseIterable {
    case women
    case men
}

protocol RosterPresenterProtocol where Self: Presenter {
    func onViewWillAppear()
    func addPressed()
    func addPlayer(_ player: PlayerModel)
    func deletePlayer(at indexPath: IndexPath)
    func goToPlayerPage(at indexPath: IndexPath)
    func numberOfRowsInSection(_ section: Int) -> Int
    func getPlayerName(at indexPath: IndexPath) -> String
}

class RosterViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: RosterPresenterProtocol!
    @IBOutlet weak var tableView: UITableView!
    
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
    
    func updateView() {
        tableView.reloadData()
    }
    
    //MARK: Actions
    @objc func addPressed() {
        presenter.addPressed()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension RosterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Gender.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Gender.women.rawValue:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                return Constants.Titles.women
            }
        case Gender.men.rawValue:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                return Constants.Titles.men
            }
        default:
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RosterTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RosterTableViewCell else {
            fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        // Configure the cell
        cell.textLabel?.text = presenter.getPlayerName(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.goToPlayerPage(at: indexPath)
    }
    
    // Support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            presenter.deletePlayer(at: indexPath)
        }
    }
}
