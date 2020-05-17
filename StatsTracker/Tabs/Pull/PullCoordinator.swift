//
//  PullCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class PullCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    //MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        self.setLargeTitles()
        
        // Create new view controller
        let vc = PullViewController.instantiate(.pull)
        vc.presenter = PullPresenter(vc: vc, delegate: self)
        
        // Create tab item
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.pullTitle, image: UIImage(systemName: "sportscourt"), tag: 2)
        
        navigationController.pushViewController(vc, animated: true)
    }
}

//MARK: PullPresenterDelegate
extension PullCoordinator: PullPresenterDelegate {
    func startGamePressed() {
        let vc = PlayGameViewController.instantiate(.pull)
        vc.presenter = PlayGamePresenter(vc: vc, delegate: self)
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true, completion: nil)
    }
}

//MARK: PlayGamePresenterDelegate
extension PullCoordinator: PlayGamePresenterDelegate { }
