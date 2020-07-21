//
//  GameDetailTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/21/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class GameDetailTableViewCell: UITableViewCell {
    
    func setup(type: Int, vm: GameViewModel) {
        switch type {
        case GameDetailCellType.score.rawValue:
            textLabel?.text = GameDetailCellType.score.description
            detailTextLabel?.text = vm.finalScore
        case GameDetailCellType.breaksFor.rawValue:
            textLabel?.text = GameDetailCellType.breaksFor.description
            detailTextLabel?.text = vm.breaksFor
        case GameDetailCellType.breaksAgainst.rawValue:
            textLabel?.text = GameDetailCellType.breaksAgainst.description
            detailTextLabel?.text = vm.breaksAgainst
        case GameDetailCellType.offensiveEfficiency.rawValue:
            textLabel?.text = GameDetailCellType.offensiveEfficiency.description
            detailTextLabel?.text = vm.offensiveEfficiency
        default:
            fatalError(Constants.Errors.playerDetailCellError)
        }
        
        let mutableAttributedString = NSMutableAttributedString(string: textLabel!.text!, attributes: Font.tableView)
        textLabel?.attributedText = mutableAttributedString
    }
}
