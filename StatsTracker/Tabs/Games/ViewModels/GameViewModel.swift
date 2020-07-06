//
//  GameViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct GameViewModel {
    
    //MARK: Properties
    let model: GameDataModel
    
    var tournament: String {
        return String(model.tournament)
    }
    
    var opponent: String {
        return String(model.opponent)
    }
    
    var finalScore: String {
        return String(model.finalScore.team) + "-" + String(model.finalScore.opponent)
    }
    
    var win: Bool {
        return model.finalScore.team > model.finalScore.opponent ? true : false
    }

    //MARK: Computed Stats
    var breaksFor: String {
        // Scored defensive points
        return String(model.points.filter { $0.type == PointType.defensive.rawValue && $0.scored }.count)
    }
    
    var breaksAgainst: String {
        // Scored defensive points
        return String(model.points.filter { $0.type == PointType.offensive.rawValue && !$0.scored }.count)
    }
    
    var offensiveEfficiency: String {
        let offensivePoints = model.points.filter { $0.type == PointType.offensive.rawValue }
        let numOffensivePoints = Double(offensivePoints.count)
        if numOffensivePoints > 0 {
            let numScoredOffensivePoints = Double(offensivePoints.filter { $0.scored }.count)
            let percentage: Double = (numScoredOffensivePoints / numOffensivePoints) * 100
            return String(percentage.rounded())
        }
        return String(0)
    }
    
    // TODO: more computed stats
    // Conversion rate?: goals / possessions
    // Game leader of goals and assists?
}
