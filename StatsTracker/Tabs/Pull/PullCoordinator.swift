//
//  PullCoordinator.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PullCoordinatorDelegate: AnyObject {
    func reloadGames()
}

class PullCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var pullNavigationController: UINavigationController?
    var lineNavigationController: UINavigationController?
    weak var delegate: PullCoordinatorDelegate?
    var authManager: AuthenticationManager = FirebaseAuthManager()
    
    var viewModel: CallLineCellViewModel!
    var gameModel: GameDataModel!
    var currentPointWind: WindDirection!
    var currentPointType: PointType!
    
    private let selectedPlayerSection = 0

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
    
    //MARK: Private methods
    private func confirmedEndGame() {
        navigationController.dismiss(animated: true, completion: nil)
        delegate?.reloadGames()
    }
    
    private func updateGameState(scored: Bool) {
        updateWind()
        updatePointType(scored: scored)
        viewModel.clearLine()
    }
    
    private func updateWind() {
        switch currentPointWind {
        case .upwind:
            currentPointWind = .downwind
        case .downwind:
            currentPointWind = .upwind
        case .crosswind:
            currentPointWind = .crosswind
        case .none:
            return
        }
    }
    
    private func updatePointType(scored: Bool) {
        // The team that scores pulls the next point (starts on defense)
        currentPointType = scored ? .defensive : .offensive
    }
}

//MARK: PullPresenterDelegate
extension PullCoordinator: PullPresenterDelegate {
    func startGamePressed(gameModel: GameDataModel, wind: WindDirection, point: PointType) {
        self.currentPointWind = wind
        self.currentPointType = point
        self.gameModel = gameModel
        
        let vc = PlayGameViewController.instantiate(.pull)
        let presenter = PlayGamePresenter(vc: vc, delegate: self, gameModel: gameModel, dbManager: FirestoreDBManager(authManager.currentUserUID))
        
        vc.presenter = presenter
        
        pullNavigationController = UINavigationController(rootViewController: vc)
        pullNavigationController?.modalPresentationStyle = .fullScreen
        navigationController.present(pullNavigationController!, animated: true, completion: nil)
    }
}

//MARK: PlayGamePresenterDelegate
extension PullCoordinator: PlayGamePresenterDelegate {
    func startPoint(vm: CallLineCellViewModel) {
        viewModel = vm
        
        let vc = CallLineViewController.instantiate(.pull)
        let presenter = CallLinePresenter(vc: vc, delegate: self, vm: viewModel)
        vc.presenter = presenter
        vc.updateWithViewModel(vm: viewModel)
        
        lineNavigationController = UINavigationController(rootViewController: vc)
        lineNavigationController!.modalPresentationStyle = .fullScreen
        pullNavigationController!.present(lineNavigationController!, animated: true, completion: nil)
    }
    
    func endGame() {
        let completionAlert = UIAlertController(title: Constants.Alerts.endGameTitle, message: Constants.Alerts.successfulRecordAlert, preferredStyle: UIAlertController.Style.alert)

        // Confirm action and end game
        completionAlert.addAction(UIAlertAction(title: Constants.Alerts.okay, style: .default, handler: { (action: UIAlertAction!) in self.confirmedEndGame() }))
        
        lineNavigationController?.topViewController?.present(completionAlert, animated: true, completion: nil)
    }
}

//MARK: CallLinePresenterDelegate
extension PullCoordinator: CallLinePresenterDelegate {
    func playPoint(vm: CallLineCellViewModel) {
        guard let vc = pullNavigationController?.viewControllers[0] as? PlayGameViewController else {
            fatalError(Constants.Errors.viewControllerError("PlayGameViewController"))
        }
        
        let selectedPlayers = vm.items[selectedPlayerSection]
        let playGameVM = PlayGameCellViewModel(playerArray: [selectedPlayers], delegate: self)
        vc.updateWithViewModel(vm: playGameVM)
        
        // Dismiss the lineNavigationController, end up at PlayGameViewController
        pullNavigationController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: PlayGameCellViewModelDelegate
extension PullCoordinator: PlayGameCellViewModelDelegate {
    func nextPoint(scored: Bool) {
        
        let point = PointDataModel(wind: currentPointWind.rawValue, scored: scored, type: currentPointType.rawValue)
        gameModel.addPoint(point: point)
        
        updateGameState(scored: scored)
        startPoint(vm: viewModel)
    }
}
