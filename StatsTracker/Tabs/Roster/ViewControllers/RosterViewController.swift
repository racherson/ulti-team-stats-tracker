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

class RosterViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: RosterPresenterProtocol!
    var viewModel: RosterCellViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the size of the tableview
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView(frame: .zero)
        
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
    
    func updateWithViewModel(vm: RosterCellViewModel) {
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
