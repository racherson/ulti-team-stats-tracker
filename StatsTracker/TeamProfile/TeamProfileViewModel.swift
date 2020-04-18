//
//  TeamProfileViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/16/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

class TeamProfileViewModel {
    var teamName: String
    
    required init(team: String) {
        self.teamName = team
    }
}
