//
//  GameDataModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct GameDataModel {
    
    //MARK: Properties
    private(set) var id: String
    private(set) var tournament: String
    private(set) var opponent: String
    private(set) var finalScore: ScoreModel
    private(set) var points: [PointDataModel]
    
    var dictionary: [String: Any] {
        return [
            Constants.GameModel.id: id,
            Constants.GameModel.tournament: tournament,
            Constants.GameModel.opponent: opponent,
            Constants.GameModel.finalScore: finalScore.dictionary,
            Constants.GameModel.points: points.compactMap { $0.dictionary }
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case tournament
        case opponent
        case finalScore
        case points
    }
    
    //MARK: Initialization
    init(id: String, tournament: String, opponent: String) {
        self.id = id
        self.tournament = tournament
        self.opponent = opponent
        self.finalScore = ScoreModel()
        self.points = []
    }
    
    init(id: String, tournament: String, opponent: String, finalScore: [String: Any], points: [[String: Any]]) {
        self.id = id
        self.tournament = tournament
        self.opponent = opponent
        self.finalScore = ScoreModel(documentData: finalScore) ?? ScoreModel()
        self.points = points.compactMap { PointDataModel(documentData: $0) }
    }
    
    mutating func addPoint(point: PointDataModel) {
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


//MARK: DocumentSerializable
extension GameDataModel: DocumentSerializable {
    init?(documentData: [String : Any]) {
        guard let id = documentData[Constants.GameModel.id] as? String,
            let tournament = documentData[Constants.GameModel.tournament] as? String,
            let opponent = documentData[Constants.GameModel.opponent] as? String,
            let finalScore = documentData[Constants.GameModel.finalScore] as? [String: Any],
            let points = documentData[Constants.GameModel.points] as? [[String: Any]] else { return nil }
        
        self.init(id: id, tournament: tournament, opponent: opponent, finalScore: finalScore, points: points)
    }
}

//MARK: CustomDebugStringConvertible
extension GameDataModel: CustomDebugStringConvertible {
    var debugDescription: String {
        return "GameDataModel(dictionary: \(dictionary))"
    }
}
