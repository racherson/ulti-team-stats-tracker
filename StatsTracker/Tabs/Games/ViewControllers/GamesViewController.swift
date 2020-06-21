//
//  GamesViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol GamesPresenterProtocol where Self: Presenter {
    func setViewModel()
}

protocol GamesCellViewModelProtocol: UITableViewDataSource {
    func goToGamePage(at indexPath: IndexPath)
}

class GamesViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: GamesPresenterProtocol!
    var viewModel: GamesCellViewModelProtocol!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the size of the tableview
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Connect tableView to the View Controller
        tableView.delegate = self
        tableView.dataSource = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateWithViewModel(vm: GamesCellViewModelProtocol) {
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
}

// MARK: UITableViewDelegate
extension GamesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.goToGamePage(at: indexPath)
    }
}
