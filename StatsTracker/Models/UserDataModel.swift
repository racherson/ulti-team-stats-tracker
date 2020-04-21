//
//  UserDataModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/15/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

extension Constants {
    struct UserDataModel {
        static let uid = "uid"
        static let teamName = "teamName"
        static let email = "email"
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
            Constants.UserDataModel.uid: uid,
            Constants.UserDataModel.teamName: teamName,
            Constants.UserDataModel.email: email
        ]
    }
}

extension UserDataModel: DocumentSerializable {
    init?(documentData: [String : Any]) {
        let uid = documentData[Constants.UserDataModel.uid] as? String ?? Constants.Empty.string
        let teamName = documentData[Constants.UserDataModel.teamName] as? String ?? Constants.Empty.string
        let email = documentData[Constants.UserDataModel.email] as? String ?? Constants.Empty.string
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
