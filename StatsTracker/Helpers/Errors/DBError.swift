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
}

//MARK: LocalizedError
extension DBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .document:
            return Constants.Errors.documentError
        case .unknown:
            return Constants.Errors.unknown
        }
    }
}
