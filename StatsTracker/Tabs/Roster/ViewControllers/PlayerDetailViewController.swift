//
//  PlayerDetailViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/21/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayerDetailPresenterProtocol where Self: Presenter { }

class PlayerDetailViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: PlayerDetailPresenterProtocol!
    var vm: PlayerViewModel?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the size of the tableview
        tableView.setUp()
        
        // Connect tableView to the View Controller
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateWithViewModel(vm: PlayerViewModel) {
        self.vm = vm
        tableView.reloadData()
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension PlayerDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayerDetailCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? vm?.roles : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlayerDetailTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlayerDetailTableViewCell else {
            fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        // Configure the cell
        cell.setup(type: indexPath.row, vm: self.vm!)
        return cell
    }
}
