//
//  PlayerStatModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/6/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct PlayerStatModel {
    var points: Int
    var games: Int
    var completions: Int
    var throwaways: Int
    var catches: Int
    var drops: Int
    var goals: Int
    var assists: Int
    var ds: Int
    var pulls: Int
    var callahans: Int
    
    init() {
        self.points = 0
        self.games = 0
        self.completions = 0
        self.throwaways = 0
        self.catches = 0
        self.drops = 0
        self.goals = 0
        self.assists = 0
        self.ds = 0
        self.pulls = 0
        self.callahans = 0
    }
}
