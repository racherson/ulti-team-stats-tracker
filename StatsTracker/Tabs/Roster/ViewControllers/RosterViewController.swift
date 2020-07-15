//
//  RosterViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol RosterPresenterProtocol where Self: Presenter {
    func setViewModel()
    func addPressed()
}

protocol RosterCellViewModelProtocol: UITableViewDataSource {
    func goToPlayerPage(at indexPath: IndexPath)
    func addPlayer(_ player: PlayerModel)
}

class RosterViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: RosterPresenterProtocol!
    var viewModel: RosterCellViewModelProtocol!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the size of the tableview
        tableView.setUp()
        
        // Connect tableView to the View Controller
        tableView.delegate = self
        tableView.dataSource = viewModel
        
        // Add pluse button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addPressed))
        self.navigationItem.rightBarButtonItem  = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateWithViewModel(vm: RosterCellViewModelProtocol) {
        viewModel = vm
        if tableView != nil {
            tableView.dataSource = vm
        }
        updateView()
    }
    
    func updateView() {
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    //MARK: Actions
    @objc func addPressed() {
        presenter.addPressed()
    }
}

// MARK: UITableViewDelegate
extension RosterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.goToPlayerPage(at: indexPath)
    }
}
