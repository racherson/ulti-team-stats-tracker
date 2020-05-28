//
//  Gender.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

enum Gender: Int, CaseIterable {
    case women
    case men
    
    var description: String {
        switch self {
        case .women:
            return Constants.Titles.women
        case .men:
            return Constants.Titles.men
        }
    }
}
