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
    var authManager: AuthenticationManager = FirebaseAuthManager()

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
    func startGamePressed(gameModel: GameDataModel, wind: WindDirection, point: PointType) {
        let vc = PlayGameViewController.instantiate(.pull)
        let presenter = PlayGamePresenter(vc: vc, delegate: self, gameModel: gameModel, dbManager: FirestoreDBManager(authManager.currentUserUID))
        presenter.currentPointWind = wind
        presenter.currentPointType = point
        vc.presenter = presenter
        
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true, completion: nil)
    }
}

//MARK: PlayGamePresenterDelegate
extension PullCoordinator: PlayGamePresenterDelegate {
    func endGame() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
