//
//  TestConstants.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit
@testable import StatsTracker

struct TestConstants {
    static let teamName = "Test"
    static let teamImage = UIImage(named: Constants.Empty.image)
    static let email = "test@t.com"
    static let empty = ""
    static let currentUID = "12345"
    static let error = NSError(domain: "", code: 0, userInfo: nil)
    
    struct Alerts {
        static let dismiss = "Dismiss"
        static let cancel = "Cancel"
        static let confirm = "Confirm"
    }
}
