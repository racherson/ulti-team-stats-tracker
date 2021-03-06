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
    var lineViewModel: CallLineCellViewModelProtocol!
    var gameModel: GameDataModel!
    var currentPointWind: WindDirection!
    var startPointType: PointType! // Point type, how the point starts
    var currentPointType: PointType! // Team currently has disc or not within the point

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
        updateNextPointType(scored: scored)
        lineViewModel.clearLine()
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
    
    private func updateNextPointType(scored: Bool) {
        // The team that scores pulls the next point (starts on defense)
        startPointType = scored ? .defensive : .offensive
        currentPointType = startPointType
    }
    
    private func updateMidPointType() {
        switch currentPointType {
        case .offensive:
            currentPointType = .defensive
        case .defensive:
            currentPointType = .offensive
        case .none:
            return
        }
    }
    
    private func updatePlayPointViewModel(pulled: Bool) {
        guard let vc = pullNavigationController?.topViewController as? PlayGameViewController else {
            fatalError(Constants.Errors.viewControllerError("PlayGameViewController"))
        }
        
        let selectedPlayers = lineViewModel.selectedPlayers
        var playGameVM: PlayGameCellViewModelProtocol
        
        switch currentPointType {
        case .offensive:
            playGameVM = PlayGameOffenseCellViewModel(playerArray: [selectedPlayers], delegate: self)
        case .defensive:
            playGameVM = PlayGameDefenseCellViewModel(playerArray: [selectedPlayers], delegate: self, pulled: pulled)
        case .none:
            return
        }
        
        vc.updateWithViewModel(vm: playGameVM)
    }
}

//MARK: PullPresenterDelegate
extension PullCoordinator: PullPresenterDelegate {
    func startGamePressed(gameModel: GameDataModel, wind: WindDirection, point: PointType) {
        self.currentPointWind = wind
        self.startPointType = point
        self.currentPointType = point
        self.gameModel = gameModel
        
        let vc = PlayGameViewController.instantiate(.pull)
        let presenter = PlayGamePresenter(vc: vc, delegate: self, gameModel: gameModel, dbManager: FirestoreDBManager(authManager.currentUserUID))
        
        vc.presenter = presenter
        
        pullNavigationController = NavigationController(rootViewController: vc)
        pullNavigationController?.modalPresentationStyle = .fullScreen
        navigationController.present(pullNavigationController!, animated: true, completion: nil)
    }
}

//MARK: PlayGamePresenterDelegate
extension PullCoordinator: PlayGamePresenterDelegate {
    func startPoint(vm: CallLineCellViewModelProtocol) {
        lineViewModel = vm
        
        let vc = CallLineViewController.instantiate(.pull)
        let presenter = CallLinePresenter(vc: vc, delegate: self, vm: lineViewModel)
        vc.presenter = presenter
        vc.updateWithViewModel(vm: lineViewModel)
        
        lineNavigationController = NavigationController(rootViewController: vc)
        lineNavigationController!.modalPresentationStyle = .fullScreen
        pullNavigationController!.present(lineNavigationController!, animated: true, completion: nil)
    }
    
    func endGame() {
        let completionAlert = UIAlertController(title: Constants.Alerts.endGameTitle, message: Constants.Alerts.successfulRecordAlert, preferredStyle: UIAlertController.Style.alert)

        // Confirm action and end game
        completionAlert.addAction(UIAlertAction(title: Constants.Alerts.okay, style: .default, handler: { (action: UIAlertAction!) in self.confirmedEndGame() }))
        
        lineNavigationController?.topViewController?.present(completionAlert, animated: true, completion: nil)
    }
    
    func defensePressed() {
        if currentPointType == .offensive {
            flipPointType()
        }
    }
    
    func opponentScorePressed() {
        if currentPointType == .defensive {
            nextPoint(scored: false)
        }
    }
}

//MARK: CallLinePresenterDelegate
extension PullCoordinator: CallLinePresenterDelegate {
    func playPoint() {
        // Get correct view model based on current point type
        updatePlayPointViewModel(pulled: false)
        
        // Dismiss the lineNavigationController, end up at PlayGameViewController
        pullNavigationController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: PlayGameOffenseCellViewModelDelegate, PlayGameDefenseCellViewModelDelegate
extension PullCoordinator: PlayGameOffenseCellViewModelDelegate, PlayGameDefenseCellViewModelDelegate {
    func nextPoint(scored: Bool) {
        
        let point = PointDataModel(wind: currentPointWind.rawValue, scored: scored, type: startPointType.rawValue)
        gameModel.addPoint(point: point)
        
        updateGameState(scored: scored)
        startPoint(vm: lineViewModel)
    }
    
    func reloadVC() {
        guard let vc = pullNavigationController?.topViewController as? PlayGameViewController else {
            fatalError("Unable to reload")
        }
        vc.tableView.reloadData()
    }
    
    func flipPointType() {
        updateMidPointType()
        updatePlayPointViewModel(pulled: true)
    }
}
