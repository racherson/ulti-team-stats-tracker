//
//  PlayGameViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/21/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGamePresenterProtocol where Self: Presenter {
    func defensePressed()
    func opponentScorePressed()
}

protocol PlayGameCellViewModelProtocol: UITableViewDataSource { }

class PlayGameViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: PlayGamePresenterProtocol!
    var viewModel: PlayGameCellViewModelProtocol!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the size of the tableview
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.dataSource = viewModel
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateWithViewModel(vm: PlayGameCellViewModelProtocol) {
        viewModel = vm
        if tableView != nil {
            tableView.dataSource = vm
        }
        
        // Setup bar buttons based on point type
        if let _ = vm as? PlayGameOffenseCellViewModel {
            setUpOffenseButton()
        }
        else if let _ = vm as? PlayGameOffenseCellViewModel {
            setUpDefenseButton()
        }
        
        updateView()
    }
    
    func updateView() {
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    //MARK: Private methods
    private func setUpOffenseButton() {
        // Add start button
        let button = UIBarButtonItem(title: "Defensive Block", style: .done, target: self, action: #selector(self.defensePressed))
        navigationItem.rightBarButtonItem  = button
    }
    
    private func setUpDefenseButton() {
        // Add start button
        let button = UIBarButtonItem(title: "Opponent Scored", style: .done, target: self, action: #selector(self.opponentScorePressed))
        navigationItem.rightBarButtonItem  = button
    }
    
    //MARK: Actions
    @objc func defensePressed() {
        presenter.defensePressed()
    }
    
    @objc func opponentScorePressed() {
        presenter.opponentScorePressed()
    }
}

//MARK: UITableViewDelegate
extension PlayGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
