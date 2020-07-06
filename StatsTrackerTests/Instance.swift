//
//  Instance.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/6/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
@testable import StatsTracker

struct Instance {
    
    static func getPlayerModel(_ gender: Gender = .women) -> PlayerModel {
        return PlayerModel(name: TestConstants.playerName, gender: gender.rawValue, id: TestConstants.empty, roles: [])
    }
    
    static func getUserDataModel() -> UserDataModel {
        return UserDataModel(teamName: TestConstants.teamName, email: TestConstants.email, imageURL: TestConstants.empty)
    }
    
    static func getGameDataModel() -> GameDataModel {
        return GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)
    }
    
    static func getScoreModel() -> ScoreModel {
        return ScoreModel(opponent: 0, team: 0)
    }
    
    struct ViewModel {
        
        static func teamProfile() -> TeamProfileViewModel {
            return TeamProfileViewModel(team: TestConstants.teamName, email: TestConstants.email, image: TestConstants.teamImage!)
        }
        
        static func callLineEmpty(delegate: CallLineCellViewModelDelegate) -> CallLineCellViewModel {
            return CallLineCellViewModel(playerArray: [[], [], []], delegate: delegate)
        }
        
        static func player() -> PlayerViewModel {
            return PlayerViewModel(model: Instance.getPlayerModel())
        }
    }
}
