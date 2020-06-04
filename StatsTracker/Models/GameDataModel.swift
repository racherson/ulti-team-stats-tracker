//
//  GameDataModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

class GameDataModel {
    
    //MARK: Properties
    private(set) var tournament: String
    private(set) var opponent: String
    private(set) var finalScore: ScoreModel
    private(set) var points: [PointDataModel]
    
    //MARK: Initialization
    init(tournament: String, opponent: String) {
        self.tournament = tournament
        self.opponent = opponent
        self.finalScore = ScoreModel()
        self.points = []
    }
    
    func addPoint(point: PointDataModel) {
        // Add point
        self.points.append(point)
        
        // Update the final score
        if point.scored {
            self.finalScore.teamScored()
        }
        else {
            self.finalScore.opponentScored()
        }
    }
}
