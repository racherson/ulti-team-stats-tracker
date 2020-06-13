//
//  GamesCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class GamesCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let authManager: AuthenticationManager = FirebaseAuthManager()
    var rootVC: GamesViewController!

    //MARK: Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        self.setLargeTitles()
        
        // Create new view controller
        let vc = GamesViewController.instantiate(.games)
        vc.presenter = GamesPresenter(vc: vc, delegate: self, dbManager: FirestoreDBManager(authManager.currentUserUID))
        rootVC = vc
        
        // Create tab item
        vc.tabBarItem = UITabBarItem(title: Constants.Titles.gamesTitle, image: UIImage(systemName: "chart.bar"), tag: 3)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func reloadGames() {
        rootVC.presenter.setViewModel()
    }
}

//MARK: GamesPresenterDelegate
extension GamesCoordinator: GamesPresenterDelegate {
    func goToGamePage(viewModel: GameViewModel) {
        let vc = GameDetailViewController.instantiate(.games)
        vc.presenter = GameDetailPresenter(vc: vc, delegate: self, viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}

//MARK: GameDetailPresenterDelegate
extension GamesCoordinator: GameDetailPresenterDelegate { }
