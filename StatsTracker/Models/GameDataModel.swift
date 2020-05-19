//
//  GameDataModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct GameDataModel {
    var tournament: String
    var opponent: String
    var finalScore: ScoreModel
    var points: [PointDataModel]
}
