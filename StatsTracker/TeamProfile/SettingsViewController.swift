//
//  SettingsViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/12/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

enum SettingCellType: Int, CaseIterable {
    case logout
    case edit
}

protocol SettingsViewControllerDelegate {
    func transitionToHome()
    func editPressed()
}

class SettingsViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var delegate: SettingsViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect tableView to the View Controller
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set the page title
        self.title = Constants.Titles.settingsTitle
    }
    
    //MARK: Actions
    func logoutPressed() {
        
        // Add confirmation alert
        let logoutAlert = UIAlertController(title: Constants.Titles.logout, message: Constants.Alerts.logoutAlert, preferredStyle: UIAlertController.Style.alert)
        
        // Cancel action and dismiss
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in logoutAlert.dismiss(animated: true, completion: nil) }))

        // Confirm action and logout
        logoutAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in self.logout() }))

        present(logoutAlert, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func logout() {
        if let logoutError = FirebaseAuthManager.logout() {
            
            // Error logging out, display alert
            let alertController = UIAlertController(title: Constants.Errors.logoutError, message:
                logoutError, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            present(alertController, animated: true, completion: nil)
        }
        else {
            // Go back to root view controller
            delegate?.transitionToHome()
        }
    }
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SettingsTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        // Configure the cell
        cell.setup(type: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Find the cell type from the row selected
        switch indexPath.row {
        case SettingCellType.logout.rawValue:
            logoutPressed()
        case SettingCellType.edit.rawValue:
            delegate?.editPressed()
        default:
            fatalError(Constants.Errors.settingCellError)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
