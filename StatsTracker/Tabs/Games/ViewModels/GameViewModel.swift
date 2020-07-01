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

    var breaks: Int {
        // Scored defensive points
        return model.points.filter { $0.type == PointType.defensive.rawValue && $0.scored }.count
    }
    
    // TODO: more computed stats
    // Offensive efficiency: offensive points scored / offensive points played
    // Conversion rate?: goals / possessions
    // Game leader of goals and assists?
}
