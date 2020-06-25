//
//  PlayGameCellViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/21/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGameCellViewModelDelegate: AnyObject { }

class PlayGameCellViewModel: NSObject {
    
    //MARK: Properties
    var items = [[PlayerViewModel]]()
    weak var delegate: PlayGameCellViewModelDelegate?
    
    private let selectedPlayerSection = 0
    
    init(playerArray: [[PlayerViewModel]], delegate: PlayGameCellViewModelDelegate?) {
        self.items = playerArray
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
    
    private func getPlayerName(at indexPath: IndexPath) -> String {
        if checkValidIndexPath(indexPath) {
            return items[indexPath.section][indexPath.row].name
        }
        return Constants.Empty.string
    }
}

//MARK: PlayGameCellViewModelProtocol
extension PlayGameCellViewModel: PlayGameCellViewModelProtocol {
    // TODO
}

//MARK: UITableViewDataSource
extension PlayGameCellViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check if section is in bounds
        return section < 0 || section >= items.count ? Constants.Empty.int : items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlayGameTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? PlayGameTableViewCell else {
                fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        // Configure the cell
        if checkValidIndexPath(indexPath) {
            cell.item = items[indexPath.section][indexPath.row]

            return cell
        }
        else {
            fatalError(Constants.Errors.oob)
        }
    }
}
