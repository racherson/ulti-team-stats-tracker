//
//  CallLineCellViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/20/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol CallLineCellViewModelDelegate: AnyObject {
    func endGame(items: [[PlayerViewModel]])
}

class CallLineCellViewModel: NSObject {
    
    //MARK: Properties
    var items = [[PlayerViewModel]]()
    weak var delegate: CallLineCellViewModelDelegate?
    
    private let selectedPlayerSection = 0
    
    init(playerArray: [[PlayerModel]], delegate: CallLineCellViewModelDelegate?) {
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
    
    private func getPlayerName(at indexPath: IndexPath) -> String {
        if checkValidIndexPath(indexPath) {
            return items[indexPath.section][indexPath.row].name
        }
        return Constants.Empty.string
    }
}

//MARK: CallLineCellViewModelProtocol
extension CallLineCellViewModel: CallLineCellViewModelProtocol {
    
    @objc func selectPlayer(at indexPath: IndexPath) -> IndexPath? {
        // Get player model
        let player = items[indexPath.section][indexPath.row]
        // Get the section to move player to, based on if they are already selected or not
        let section = indexPath.section == selectedPlayerSection ? player.gender.rawValue + 1 : selectedPlayerSection
        
        // Don't select more than 7 players
        if section == selectedPlayerSection && items[selectedPlayerSection].count >= Constants.fullLine {
            return nil
        }
        
        // Add to selected array
        items[section].append(player)
        // Remove from gender array
        items[indexPath.section].remove(at: indexPath.row)
        
        return IndexPath(row: items[section].count - 1, section: section)
    }
    
    @objc func endGame() {
        delegate?.endGame(items: items)
    }
    
    @objc func fullLine() -> Bool {
        // Check if selected array has 7 players
        return items[selectedPlayerSection].count < Constants.fullLine ? false : true
    }
    
    func clearLine() {
        // Add players back to their gender arrays
        for player in items[selectedPlayerSection] {
            items[player.gender.rawValue + 1].append(player)
        }
        
        // Remove all players from selected array
        items[selectedPlayerSection].removeAll()
    }
}

//MARK: UITableViewDataSource
extension CallLineCellViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Check if section is in bounds
        return section < 0 || section >= items.count ? Constants.Empty.int : items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "CallLineCollectionViewCell"
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            as? CallLineCollectionViewCell else {
                fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        // Configure the cell
        switch indexPath.section {
        case Gender.women.rawValue + 1:
            cell.backgroundColor = .red
        case Gender.men.rawValue + 1:
            cell.backgroundColor = .blue
        default:
            cell.backgroundColor = .gray
        }
        
        if checkValidIndexPath(indexPath) {
            cell.item = items[indexPath.section][indexPath.row]

            return cell
        }
        else {
            fatalError(Constants.Errors.oob)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView( ofKind: kind, withReuseIdentifier: "\(CallLineCollectionHeaderView.self)", for: indexPath) as? CallLineCollectionHeaderView else {
                fatalError("Invalid view type")
            }
            
            if let gender = Gender(rawValue: indexPath.section - 1)?.description {
                headerView.label.text = gender
            }
            else {
                headerView.label.text = Constants.Titles.lineTitle
            }
            
            return headerView
            
        default:
            fatalError("Invalid element type")
        }
    }
}
