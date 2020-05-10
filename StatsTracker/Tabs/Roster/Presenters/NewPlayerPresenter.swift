//
//  NewPlayerPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol NewPlayerPresenterDelegate: AnyObject {
    func cancelPressed()
    func savePressed(player: PlayerModel)
}

class NewPlayerPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: NewPlayerPresenterDelegate?
    weak var vc: NewPlayerViewController!
    var dbManager: DatabaseManager
    var model: PlayerModel?
    
    //MARK: Initialization
    init(vc: NewPlayerViewController, delegate: NewPlayerPresenterDelegate?, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.dbManager = dbManager
        self.dbManager.setDataDelegate = self
    }
    
    //MARK: Private methods
    private func showErrorAlert(error: String) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.userSavingError, message:
            error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Alerts.dismiss, style: .default))

        vc.present(alertController, animated: true, completion: nil)
    }
}

//MARK: NewPlayerPresenterProtocol
extension NewPlayerPresenter: NewPlayerPresenterProtocol {
    
    func onViewWillAppear() {
        vc.navigationItem.title = Constants.Titles.newPlayerTitle
    }
    
    func cancelPressed() {
        delegate?.cancelPressed()
    }
    
    func savePressed(model: PlayerModel) {
        self.model = model
        dbManager.setData(data: model.dictionary, collection: .roster)
    }
    
    func displaySavingError() {
        self.showErrorAlert(error: Constants.Errors.userSavingError)
    }
}

//MARK: DatabaseManagerSetDataDelegate
extension NewPlayerPresenter: DatabaseManagerSetDataDelegate {
    func displayError(with error: Error) {
        self.showErrorAlert(error: error.localizedDescription)
    }
    
    func onSuccessfulSet() {
        guard let model = self.model else {
            self.showErrorAlert(error: Constants.Errors.userSavingError)
            return
        }
        self.delegate?.savePressed(player: model)
    }
}
