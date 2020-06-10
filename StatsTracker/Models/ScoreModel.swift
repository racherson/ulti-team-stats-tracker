//
//  ScoreModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct ScoreModel {
    
    //MARK: Properties
    private(set) var opponent: Int
    private(set) var team: Int
    
    var dictionary: [String: Any] {
        return [
            Constants.ScoreModel.team: team,
            Constants.ScoreModel.opponent: opponent
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case opponent
        case team
    }
    
    //MARK: Initialization
    init() {
        self.opponent = 0
        self.team = 0
    }
    
    init(opponent: Int, team: Int) {
        self.opponent = opponent
        self.team = team
    }
    
    mutating func opponentScored() {
        self.opponent += 1
    }
    
    mutating func teamScored() {
        self.team += 1
    }
}

//MARK: DocumentSerializable
extension ScoreModel: DocumentSerializable {
    init?(documentData: [String : Any]) {
        guard let opponent = documentData[Constants.ScoreModel.opponent] as? Int,
            let team = documentData[Constants.ScoreModel.team] as? Int else { return nil }
        
        self.init(opponent: opponent, team: team)
    }
}

//MARK: CustomDebugStringConvertible
extension ScoreModel: CustomDebugStringConvertible {
    var debugDescription: String {
        return "ScoreModel(dictionary: \(dictionary))"
    }
}
