//
//  PlayGameOffenseCellViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/21/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGameOffenseCellViewModelDelegate: AnyObject {
    func nextPoint(scored: Bool)
    func reloadVC()
    func flipPointType()
}

class PlayGameOffenseCellViewModel: NSObject {
    
    //MARK: Properties
    var items = [[PlayerViewModel]]()
    weak var delegate: PlayGameOffenseCellViewModelDelegate?
    var hasDiscIndex: IndexPath?
    var pickedUp: Bool = false
    
    //MARK: Initialization
    init(playerArray: [[PlayerViewModel]], delegate: PlayGameOffenseCellViewModelDelegate?) {
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
extension PlayGameOffenseCellViewModel: PlayGameCellViewModelProtocol { }

//MARK: UITableViewDataSource
extension PlayGameOffenseCellViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check if section is in bounds
        return section < 0 || section >= items.count ? Constants.Empty.int : items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // All shared properities would belong to this class
        var cell: PlayGameOffenseTableViewCell
        
        if !pickedUp {
            cell = tableView.dequeueReusableCell(withIdentifier: "PickUpDiscTableViewCell", for: indexPath) as! PickUpDiscTableViewCell
            if let cell = cell as? PickUpDiscTableViewCell {
                cell.delegate = self
            }
        }
        else {
            if indexPath == hasDiscIndex {
                cell = tableView.dequeueReusableCell(withIdentifier: "HasDiscTableViewCell", for: indexPath) as! HasDiscTableViewCell
                if let cell = cell as? HasDiscTableViewCell {
                    cell.delegate = self
                }
            }
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: "NoDiscTableViewCell", for: indexPath) as! NoDiscTableViewCell
                if let cell = cell as? NoDiscTableViewCell {
                    cell.delegate = self
                }
            }
        }
        
        // Configure the cell, properties that both subclasses share can be set here
        if checkValidIndexPath(indexPath) {
            cell.item = items[indexPath.section][indexPath.row]
            cell.index = indexPath
            return cell
        }
        else {
            fatalError(Constants.Errors.oob)
        }
    }
}

//MARK: NoDiscCellDelegate, PickUpDiscCellDelegate
extension PlayGameOffenseCellViewModel: NoDiscCellDelegate, PickUpDiscCellDelegate {
    func scorePressed() {
        if let indexPath = hasDiscIndex  {
            items[indexPath.section][indexPath.row].addAssist()
        }
        hasDiscIndex = nil
        // We scored on offense
        delegate?.nextPoint(scored: true)
    }
    
    func catchDisc(_ index: IndexPath) {
        if let indexPath = hasDiscIndex {
            // Disc was thrown by a teammate
            items[indexPath.section][indexPath.row].addCompletion()
        }
        hasDiscIndex = index
        pickedUp = true
        delegate?.reloadVC()
    }
    
    func dropDisc() {
        hasDiscIndex = nil
        delegate?.flipPointType()
    }
    
    func pickUpPressed(_ index: IndexPath) {
        hasDiscIndex = index
        pickedUp = true
        delegate?.reloadVC()
    }
}

//MARK: HasDiscCellDelegate
extension PlayGameOffenseCellViewModel: HasDiscCellDelegate {
    func turnover() {
        hasDiscIndex = nil
        delegate?.flipPointType()
    }
}
