//
//  GameDetailCellType.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/21/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

enum GameDetailCellType: Int, CaseIterable {
    case score
    case breaksFor
    case breaksAgainst
    case offensiveEfficiency
    
    var description: String {
        switch self {
        case .score:
            return Constants.Stats.score
        case .breaksFor:
            return Constants.Stats.breaksFor
        case .breaksAgainst:
            return Constants.Stats.breaksAgainst
        case .offensiveEfficiency:
            return Constants.Stats.offensiveEfficiency
        }
    }
}
