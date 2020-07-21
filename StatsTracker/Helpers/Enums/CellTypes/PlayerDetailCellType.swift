//
//  PlayerDetailCellType.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/21/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

enum PlayerDetailCellType: Int, CaseIterable {
    case games
    case points
    case goals
    case assists
    case ds
    case completions
    case throwaways
    case completionPercent
    case catches
    case drops
    case catchingPercent
    case pulls
    case callahans
    
    var description: String {
        switch self {
        case .games:
            return Constants.Stats.games
        case .points:
            return Constants.Stats.points
        case .goals:
            return Constants.Stats.goals
        case .assists:
            return Constants.Stats.assists
        case .ds:
            return Constants.Stats.ds
        case .completions:
            return Constants.Stats.completions
        case .throwaways:
            return Constants.Stats.throwaways
        case .completionPercent:
            return Constants.Stats.completionPercent
        case .catches:
            return Constants.Stats.catches
        case .drops:
            return Constants.Stats.drops
        case .catchingPercent:
            return Constants.Stats.catchingPercent
        case .pulls:
            return Constants.Stats.pulls
        case .callahans:
            return Constants.Stats.callahans
        }
    }
}
