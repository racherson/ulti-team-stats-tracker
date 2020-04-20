//
//  UserDataModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/15/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct MyKey {
    struct UserDataModel {
        static let uid = "uid"
        static let teamName = "teamName"
        static let email = "email"
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

struct UserDataModel {
    private(set) var uid: String
    private(set) var teamName: String
    private(set) var email: String
    
    var dictionary: [String: Any] {
        return [
            MyKey.UserDataModel.uid: uid,
            MyKey.UserDataModel.teamName: teamName,
            MyKey.UserDataModel.email: email
        ]
    }
}

extension UserDataModel: DocumentSerializable {
    init?(documentData: [String : Any]) {
        let uid = documentData[MyKey.UserDataModel.uid] as? String ?? MyValue.Empty.string
        let teamName = documentData[MyKey.UserDataModel.teamName] as? String ?? MyValue.Empty.string
        let email = documentData[MyKey.UserDataModel.email] as? String ?? MyValue.Empty.string
        self.init(uid: uid, teamName: teamName, email: email)
    }
}

extension UserDataModel: CustomDebugStringConvertible {
    var debugDescription: String {
        return "TeamDataModel(dictionary: \(dictionary))"
    }
}

extension UserDataModel: CustomStringConvertible {
    var description: String {
        return "TeamDataModel(teamName: \(teamName))"
    }
}
