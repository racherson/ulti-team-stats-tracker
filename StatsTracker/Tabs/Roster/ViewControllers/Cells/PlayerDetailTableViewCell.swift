//
//  PlayerDetailTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/21/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class PlayerDetailTableViewCell: UITableViewCell {
    
    func setup(type: Int, vm: PlayerViewModel) {
        switch type {
        case PlayerDetailCellType.games.rawValue:
            textLabel?.text = PlayerDetailCellType.games.description
            detailTextLabel?.text = vm.games
        case PlayerDetailCellType.points.rawValue:
            textLabel?.text = PlayerDetailCellType.points.description
            detailTextLabel?.text = vm.points
        case PlayerDetailCellType.goals.rawValue:
            textLabel?.text = PlayerDetailCellType.goals.description
            detailTextLabel?.text = vm.goals
        case PlayerDetailCellType.assists.rawValue:
            textLabel?.text = PlayerDetailCellType.assists.description
            detailTextLabel?.text = vm.assists
        case PlayerDetailCellType.ds.rawValue:
            textLabel?.text = PlayerDetailCellType.ds.description
            detailTextLabel?.text = vm.ds
        case PlayerDetailCellType.completions.rawValue:
            textLabel?.text = PlayerDetailCellType.completions.description
            detailTextLabel?.text = vm.completions
        case PlayerDetailCellType.throwaways.rawValue:
            textLabel?.text = PlayerDetailCellType.throwaways.description
            detailTextLabel?.text = vm.throwaways
        case PlayerDetailCellType.completionPercent.rawValue:
            textLabel?.text = PlayerDetailCellType.completionPercent.description
            detailTextLabel?.text = vm.completionPercentage
        case PlayerDetailCellType.catches.rawValue:
            textLabel?.text = PlayerDetailCellType.catches.description
            detailTextLabel?.text = vm.catches
        case PlayerDetailCellType.drops.rawValue:
            textLabel?.text = PlayerDetailCellType.drops.description
            detailTextLabel?.text = vm.drops
        case PlayerDetailCellType.catchingPercent.rawValue:
            textLabel?.text = PlayerDetailCellType.catchingPercent.description
            detailTextLabel?.text = vm.catchingPercentage
        case PlayerDetailCellType.pulls.rawValue:
            textLabel?.text = PlayerDetailCellType.pulls.description
            detailTextLabel?.text = vm.pulls
        case PlayerDetailCellType.callahans.rawValue:
            textLabel?.text = PlayerDetailCellType.callahans.description
            detailTextLabel?.text = vm.callahans
        default:
            fatalError(Constants.Errors.playerDetailCellError)
        }
        
        let mutableAttributedString = NSMutableAttributedString(string: textLabel!.text!, attributes: Font.tableView)
        textLabel?.attributedText = mutableAttributedString
    }
}
