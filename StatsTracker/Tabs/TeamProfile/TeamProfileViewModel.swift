//
//  TeamProfileViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/16/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class TeamProfileViewModel {
    var teamName: String
    var teamImage: UIImage
    
    required init(team: String, image: UIImage) {
        self.teamName = team
        self.teamImage = image
    }
}
