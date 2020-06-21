//
//  GamesCellViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol GamesCellViewModelDelegate: AnyObject {
    func goToGamePage(viewModel: GameViewModel)
    func updateView()
    func displayError(with: Error)
}

class GamesCellViewModel: NSObject {
    
    //MARK: Properties
    var items = [[GameViewModel]]()
    weak var delegate: GamesCellViewModelDelegate?
    
    init(gameArray: [[GameDataModel]], delegate: GamesCellViewModelDelegate?) {
        self.items = gameArray.map { $0.map { GameViewModel(model: $0) } }
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

//MARK: GamesCellViewModelProtocol
extension GamesCellViewModel: GamesCellViewModelProtocol {
    
    func goToGamePage(at indexPath: IndexPath) {
        if checkValidIndexPath(indexPath) {
            let viewModel = items[indexPath.section][indexPath.row]
            
            delegate?.goToGamePage(viewModel: viewModel)
        }
        else {
            delegate?.displayError(with: CustomError.outOfBounds)
        }
    }
}

//MARK: UITableViewDataSource
extension GamesCellViewModel: UITableViewDataSource {
    
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
        let cellIdentifier = "GamesTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GamesTableViewCell else {
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
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            // Get the tournament of the first cell
            return items[section][0].tournament
        }
        return nil
    }
}
