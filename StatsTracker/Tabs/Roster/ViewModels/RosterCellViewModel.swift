//
//  RosterCellViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/11/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol RosterCellViewModelDelegate: AnyObject {
    func goToPlayerPage(viewModel: PlayerViewModel)
    func deletePlayer(_ player: PlayerModel)
    func updateView()
    func displayError(with: Error)
}

class RosterCellViewModel: NSObject {
    
    //MARK: Properties
    var items = [[PlayerViewModel]]()
    weak var delegate: RosterCellViewModelDelegate?
    
    init(playerArray: [[PlayerModel]], delegate: RosterCellViewModelDelegate?) {
        self.items = playerArray.map { $0.map { PlayerViewModel(model: $0) } }
        self.delegate = delegate
    }
    
    //MARK: Private methods
    private func checkValidIndexPath(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        
        // Check if section in bounds
        if section < 0 || section >= items.count {
            return false
        }
        
        // Check if row in bounds given the section
        if row < 0 || row >= items[section].count {
            return false
        }
        
        return true
    }
}

//MARK: RosterCellViewModelProtocol
extension RosterCellViewModel: RosterCellViewModelProtocol {
    
    func addPlayer(_ player: PlayerModel) {
        // Update player array
        let item = PlayerViewModel(model: player)
        items[player.gender].append(item)
        delegate?.updateView()
    }
    
    func goToPlayerPage(at indexPath: IndexPath) {
        if checkValidIndexPath(indexPath) {
            let viewModel = items[indexPath.section][indexPath.row]
            
            delegate?.goToPlayerPage(viewModel: viewModel)
        }
        else {
            delegate?.displayError(with: CustomError.outOfBounds)
        }
    }
}

//MARK: UITableViewDataSource
extension RosterCellViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 0 || section >= items.count {
            return Constants.Empty.int
        }
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RosterTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RosterTableViewCell else {
            fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        if checkValidIndexPath(indexPath) {
            cell.item = items[indexPath.section][indexPath.row]
            
            return cell
        }
        else {
            fatalError(Constants.Errors.oob)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Gender.women.rawValue:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                return Gender.women.description
            }
        case Gender.men.rawValue:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                return Gender.men.description
            }
        default:
            return nil
        }
        return nil
    }
    
    // Support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if checkValidIndexPath(indexPath) {
                
                // Delete from database
                delegate?.deletePlayer(items[indexPath.section][indexPath.row].model)
                
                // Update player array
                items[indexPath.section].remove(at: indexPath.row)
                
                delegate?.updateView()
            }
        }
    }
}
