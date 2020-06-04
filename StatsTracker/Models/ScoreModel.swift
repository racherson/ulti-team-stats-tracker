//
//  ScoreModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

class ScoreModel {
    
    //MARK: Properties
    private(set) var opponentScore: Int
    private(set) var teamScore: Int
    
    //MARK: Initialization
    init() {
        self.opponentScore = 0
        self.teamScore = 0
    }
    
    init(opponent: Int, team: Int) {
        self.opponentScore = opponent
        self.teamScore = team
    }
    
    func opponentScored() {
        self.opponentScore += 1
    }
    
    func teamScored() {
        self.teamScore += 1
    }
}
