//
//  PlayGameDefenseCellViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGameDefenseCellViewModelDelegate: AnyObject {
    func nextPoint(scored: Bool)
    func flipPointType()
}

class PlayGameDefenseCellViewModel: NSObject {
    
    //MARK: Properties
    var items = [[PlayerViewModel]]()
    weak var delegate: PlayGameDefenseCellViewModelDelegate?
    
    //MARK: Initialization
    init(playerArray: [[PlayerViewModel]], delegate: PlayGameDefenseCellViewModelDelegate?) {
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
extension PlayGameDefenseCellViewModel: PlayGameCellViewModelProtocol { }

//MARK: UITableViewDataSource
extension PlayGameDefenseCellViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check if section is in bounds
        return section < 0 || section >= items.count ? Constants.Empty.int : items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlayGameDefenseTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlayGameDefenseTableViewCell else {
            fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        // Configure the cell, properties that both subclasses share can be set here
        if checkValidIndexPath(indexPath) {
            cell.item = items[indexPath.section][indexPath.row]
            cell.delegate = self
            cell.index = indexPath
            return cell
        }
        else {
            fatalError(Constants.Errors.oob)
        }
    }
}

//MARK: PlayGameDefenseCellDelegate
extension PlayGameDefenseCellViewModel: PlayGameDefenseCellDelegate {
    func dPressed() {
        delegate?.flipPointType()
    }
    
    func callahanPressed() {
        // We scored on defense
        delegate?.nextPoint(scored: true)
    }
}
