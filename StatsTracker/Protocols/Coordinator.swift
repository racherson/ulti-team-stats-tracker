//
//  Coordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol Coordinator {
    // Protocol from https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
