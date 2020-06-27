//
//  CallLinePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol CallLinePresenterDelegate: AnyObject {
    func playPoint(vm: CallLineCellViewModelProtocol)
}

protocol CallLineCellViewModelProtocol: UICollectionViewDataSource {
    var items: [[PlayerViewModel]] { get set }
    func selectPlayer(at indexPath: IndexPath) -> IndexPath?
    func endGame()
    func fullLine() -> Bool
    func addPointsToPlayers()
}

class CallLinePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: CallLinePresenterDelegate?
    weak var vc: CallLineViewController!
    weak var vm: CallLineCellViewModelProtocol!
    
    //MARK: Initialization
    init(vc: CallLineViewController, delegate: CallLinePresenterDelegate, vm: CallLineCellViewModelProtocol) {
        self.vc = vc
        self.delegate = delegate
        self.vm = vm
    }
    
    func onViewWillAppear() {
        if vm != nil {
            vc.updateWithViewModel(vm: vm)
        }
    }
    
    //MARK: Private methods
    private func showErrorAlert(error: String) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.documentErrorTitle, message:
            error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Alerts.dismiss, style: .default))

        vc.present(alertController, animated: true, completion: nil)
    }
    
    private func displayConfirmAlert() {
        let confirmationAlert = UIAlertController(title: Constants.Alerts.startGameTitle, message: Constants.Alerts.startGameAlert, preferredStyle: UIAlertController.Style.alert)
        
        // Cancel action and dismiss
        confirmationAlert.addAction(UIAlertAction(title: Constants.Alerts.cancel, style: .destructive, handler: { (action: UIAlertAction!) in confirmationAlert.dismiss(animated: true, completion: nil) }))

        // Confirm action and start point
        confirmationAlert.addAction(UIAlertAction(title: Constants.Alerts.confirm, style: .default, handler: { (action: UIAlertAction!) in self.confirmedStartPoint() }))

        vc.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func confirmedStartPoint() {
        // Give players stat of playing a point
        vm.addPointsToPlayers()
        // Hide player selection UI and display point UI
        delegate?.playPoint(vm: vm)
    }
}

//MARK: CallLinePresenterProtocol
extension CallLinePresenter: CallLinePresenterProtocol {
    
    func startPoint() {
        if !vm.fullLine() {
            displayConfirmAlert()
        }
        else {
            confirmedStartPoint()
        }
    }
    
    func selectPlayer(at indexPath: IndexPath) -> IndexPath? {
        return vm.selectPlayer(at: indexPath)
    }
    
    func endGame() {
        vm.endGame()
    }
}
