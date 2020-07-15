//
//  DBError.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/30/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

enum DBError: Error {
    case document
    case unknown
    case model
}

//MARK: LocalizedError
extension DBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .document:
            return NSLocalizedString(Constants.Errors.documentError, comment: "Document Error")
        case .unknown:
            return NSLocalizedString(Constants.Errors.unknown, comment: "Unknown Error")
        case .model:
            return NSLocalizedString(Constants.Errors.modelError, comment: "Model Error")
        }
    }
}
