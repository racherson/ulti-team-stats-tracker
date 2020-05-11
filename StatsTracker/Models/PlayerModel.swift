//
//  PlayerModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/6/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct PlayerModel: Codable {
    
    //MARK: Properties
    private(set) var id: String
    private(set) var name: String
    private(set) var gender: Int
    private(set) var points: Int
    private(set) var games: Int
    private(set) var completions: Int
    private(set) var throwaways: Int
    private(set) var catches: Int
    private(set) var drops: Int
    private(set) var goals: Int
    private(set) var assists: Int
    private(set) var ds: Int
    private(set) var pulls: Int
    private(set) var callahans: Int
    
    var dictionary: [String: Any] {
        return [
            Constants.PlayerModel.id: id,
            Constants.PlayerModel.name: name,
            Constants.PlayerModel.gender: gender,
            Constants.PlayerModel.points: points,
            Constants.PlayerModel.games: games,
            Constants.PlayerModel.completions: completions,
            Constants.PlayerModel.throwaways: throwaways,
            Constants.PlayerModel.catches: catches,
            Constants.PlayerModel.drops: drops,
            Constants.PlayerModel.goals: goals,
            Constants.PlayerModel.assists: assists,
            Constants.PlayerModel.ds: ds,
            Constants.PlayerModel.pulls: pulls,
            Constants.PlayerModel.callahans: callahans
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case gender
        case points
        case games
        case completions
        case throwaways
        case catches
        case drops
        case goals
        case assists
        case ds
        case pulls
        case callahans
    }
    
    init(name: String, gender: Int, id: String) {
        self.name = name
        self.gender = gender
        self.id = id
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
    
    init(name: String, gender: Int, id: String, points: Int, games: Int, completions: Int, throwaways: Int, catches: Int, drops: Int, goals: Int, assists: Int, ds: Int, pulls: Int, callahans: Int) {
        self.name = name
        self.gender = gender
        self.id = id
        self.points = points
        self.games = games
        self.completions = completions
        self.throwaways = throwaways
        self.catches = catches
        self.drops = drops
        self.goals = goals
        self.assists = assists
        self.ds = ds
        self.pulls = pulls
        self.callahans = callahans
    }
    
    
}

//MARK: DocumentSerializable
extension PlayerModel: DocumentSerializable {
    init?(documentData: [String : Any]) {
        guard let name = documentData[Constants.PlayerModel.name] as? String,
            let gender = documentData[Constants.PlayerModel.gender] as? Int,
            let id = documentData[Constants.PlayerModel.id] as? String else { return nil }
        
        let points = documentData[Constants.PlayerModel.points] as? Int ?? Constants.Empty.int
        let games = documentData[Constants.PlayerModel.games] as? Int ?? Constants.Empty.int
        let completions = documentData[Constants.PlayerModel.completions] as? Int ?? Constants.Empty.int
        let throwaways = documentData[Constants.PlayerModel.throwaways] as? Int ?? Constants.Empty.int
        let catches = documentData[Constants.PlayerModel.catches] as? Int ?? Constants.Empty.int
        let drops = documentData[Constants.PlayerModel.drops] as? Int ?? Constants.Empty.int
        let goals = documentData[Constants.PlayerModel.goals] as? Int ?? Constants.Empty.int
        let assists = documentData[Constants.PlayerModel.assists] as? Int ?? Constants.Empty.int
        let ds = documentData[Constants.PlayerModel.ds] as? Int ?? Constants.Empty.int
        let pulls = documentData[Constants.PlayerModel.pulls] as? Int ?? Constants.Empty.int
        let callahans = documentData[Constants.PlayerModel.callahans] as? Int ?? Constants.Empty.int
        
        self.init(name: name, gender: gender, id: id, points: points, games: games, completions: completions, throwaways: throwaways, catches: catches, drops: drops, goals: goals, assists: assists, ds: ds, pulls: pulls, callahans: callahans)
    }
}

//MARK: CustomDebugStringConvertible
extension PlayerModel: CustomDebugStringConvertible {
    var debugDescription: String {
        return "PlayerModel(dictionary: \(dictionary))"
    }
}

//MARK: CustomStringConvertible
extension PlayerModel: CustomStringConvertible {
    var description: String {
        return "PlayerModel(name: \(name))"
    }
}
