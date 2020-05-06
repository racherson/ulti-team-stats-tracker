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
    var viewModel: RosterViewModel { get }
    func onViewWillAppear()
    func addPressed()
    func addPlayer(_ player: PlayerViewModel)
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
    
    func updateWithViewModel(viewModel: RosterViewModel) {
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
        return presenter.viewModel.cellViewModels[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Gender.women.rawValue:
            return Constants.Titles.women
        case Gender.men.rawValue:
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
        cell.textLabel?.text = presenter.viewModel.cellViewModels[indexPath.section][indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Go to player page
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
