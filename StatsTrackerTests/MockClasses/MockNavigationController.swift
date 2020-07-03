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
    var pushedController: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        presentCalledCount += 1
        presentationStyle = viewControllerToPresent.modalPresentationStyle
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        pushedController = viewController
        pushCallCount += 1
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        dismissCallCount += 1
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        super.popViewController(animated: animated)
        popCallCount += 1
        return super.popViewController(animated: animated)
    }
}
