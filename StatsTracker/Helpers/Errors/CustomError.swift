//
//  CustomError.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case outOfBounds
}

//MARK: LocalizedError
extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .outOfBounds:
            return NSLocalizedString(Constants.Errors.oob, comment: "Out of Bounds Error")
        }
    }
}
