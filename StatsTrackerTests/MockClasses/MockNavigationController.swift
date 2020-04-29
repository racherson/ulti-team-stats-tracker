//
//  MockNavigationController.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class MockNavigationController: UINavigationController {
    
    var presentationStyle: UIModalPresentationStyle?
    var presentCalledCount: Int = 0
    var pushCallCount: Int = 0
    var dismissCallCount: Int = 0
    var popCallCount: Int = 0
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalledCount += 1
        presentationStyle = viewControllerToPresent.modalPresentationStyle
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushCallCount += 1
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCallCount += 1
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popCallCount += 1
        return super.popViewController(animated: animated)
    }
}
