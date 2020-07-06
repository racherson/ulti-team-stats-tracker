//
//  PlayerModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/6/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

class PlayerModel: Codable, DocumentSerializable {
    
    //MARK: Properties
    private(set) var id: String
    private(set) var name: String
    private(set) var gender: Int
    private(set) var points: Int
    private(set) var games: Int
    private(set) var completions: Double
    private(set) var throwaways: Double
    private(set) var catches: Double
    private(set) var drops: Double
    private(set) var goals: Int
    private(set) var assists: Int
    private(set) var ds: Int
    private(set) var pulls: Int
    private(set) var callahans: Int
    private(set) var roles: [Int]
    
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
            Constants.PlayerModel.callahans: callahans,
            Constants.PlayerModel.roles: roles
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
        case roles
    }
    
    init(name: String, gender: Int, id: String, roles: [Int]) {
        self.name = name
        self.gender = gender
        self.id = id
        self.roles = roles
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
    
    init(name: String, gender: Int, id: String, points: Int, games: Int, completions: Double, throwaways: Double, catches: Double, drops: Double, goals: Int, assists: Int, ds: Int, pulls: Int, callahans: Int, roles: [Int]) {
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
        self.roles = roles
    }
    
    required convenience init?(documentData: [String : Any]) {
        guard let name = documentData[Constants.PlayerModel.name] as? String,
            let gender = documentData[Constants.PlayerModel.gender] as? Int,
            let id = documentData[Constants.PlayerModel.id] as? String,
            let roles = documentData[Constants.PlayerModel.roles] as? [Int] else { return nil }
        
        let points = documentData[Constants.PlayerModel.points] as? Int ?? Constants.Empty.int
        let games = documentData[Constants.PlayerModel.games] as? Int ?? Constants.Empty.int
        let completions = documentData[Constants.PlayerModel.completions] as? Double ?? Constants.Empty.double
        let throwaways = documentData[Constants.PlayerModel.throwaways] as? Double ?? Constants.Empty.double
        let catches = documentData[Constants.PlayerModel.catches] as? Double ?? Constants.Empty.double
        let drops = documentData[Constants.PlayerModel.drops] as? Double ?? Constants.Empty.double
        let goals = documentData[Constants.PlayerModel.goals] as? Int ?? Constants.Empty.int
        let assists = documentData[Constants.PlayerModel.assists] as? Int ?? Constants.Empty.int
        let ds = documentData[Constants.PlayerModel.ds] as? Int ?? Constants.Empty.int
        let pulls = documentData[Constants.PlayerModel.pulls] as? Int ?? Constants.Empty.int
        let callahans = documentData[Constants.PlayerModel.callahans] as? Int ?? Constants.Empty.int
        
        self.init(name: name, gender: gender, id: id, points: points, games: games, completions: completions, throwaways: throwaways, catches: catches, drops: drops, goals: goals, assists: assists, ds: ds, pulls: pulls, callahans: callahans, roles: roles)
    }
}

//MARK: Add Stats
extension PlayerModel {
    
    func addPoint() {
        self.points += 1
    }
    
    func addGame() {
        self.games += 1
    }
    
    func addCompletion() {
        self.completions += 1
    }
    
    func addThrowaway() {
        self.throwaways += 1
    }
    
    func addCatch() {
        self.catches += 1
    }
    
    func addDrop() {
        self.drops += 1
    }
    
    func addGoal() {
        self.goals += 1
    }
    
    func addAssist() {
        self.assists += 1
    }
    
    func addD() {
        self.ds += 1
    }
    
    func addPull() {
        self.pulls += 1
    }
    
    func addCallahan() {
        self.callahans += 1
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
