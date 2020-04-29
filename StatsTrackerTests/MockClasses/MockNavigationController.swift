//
//  MockNavigationController.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class MockNavigationController: UINavigationController {
    
    var presentCalledCount: Int = 0
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalledCount += 1
    }
}
