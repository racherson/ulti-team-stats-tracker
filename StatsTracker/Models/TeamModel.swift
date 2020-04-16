//
//  TeamModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/15/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct MyKey {
    struct TeamModel {
        static let uid = "uid"
        static let teamName = "teamName"
    }
}

struct MyValue {
    struct Empty {
        static let string = ""
        static let int = 0
    }
}

protocol DocumentSerializable {
    init?(documentData: [String: Any])
}

struct TeamModel {
    private(set) var uid: String
    private(set) var teamName: String
    
    var dictionary: [String: Any] {
        return [
            MyKey.TeamModel.uid: uid,
            MyKey.TeamModel.teamName: teamName
        ]
    }
}

extension TeamModel: DocumentSerializable {
    init?(documentData: [String : Any]) {
        let uid = documentData[MyKey.TeamModel.uid] as? String ?? MyValue.Empty.string
        let teamName = documentData[MyKey.TeamModel.teamName] as? String ?? MyValue.Empty.string
        self.init(uid: uid, teamName: teamName)
    }
}

extension TeamModel: CustomDebugStringConvertible {
    var debugDescription: String {
        return "TeamModel(dictionary: \(dictionary))"
    }
}

extension TeamModel: CustomStringConvertible {
    var description: String {
        return "TeamModel(teamName: \(teamName))"
    }
}
