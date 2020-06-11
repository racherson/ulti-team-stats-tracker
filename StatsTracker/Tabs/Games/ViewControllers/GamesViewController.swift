//
//  GamesViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol GamesPresenterProtocol where Self: Presenter {
    func setTournamentArrays()
    func numberOfTournaments() -> Int
    func numberOfGamesInSection(_ section: Int) -> Int
    func getGameOpponent(at indexPath: IndexPath) -> String
    func getTournament(at indexPath: IndexPath) -> String
    func goToGamePage(at indexPath: IndexPath)
}

class GamesViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: GamesPresenterProtocol!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the size of the tableview
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Connect tableView to the View Controller
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateView() {
        if tableView != nil {
            tableView.reloadData()
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension GamesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfTournaments()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfGamesInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GamesTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GamesTableViewCell else {
            fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        // Configure the cell
        cell.textLabel?.text = presenter.getGameOpponent(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.goToGamePage(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            // Get the tournament of the first cell
            return presenter.getTournament(at: IndexPath(row: 0, section: section))
        }
        return nil
    }
}
