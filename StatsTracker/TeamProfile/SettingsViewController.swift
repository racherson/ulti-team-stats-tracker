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

class SettingsViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var delegate: TeamProfileCoordinator?
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
        let logoutAlert = UIAlertController(title: "Log Out", message: Constants.Alerts.logoutAlert, preferredStyle: UIAlertController.Style.alert)
        
        // Cancel action and dismiss
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in logoutAlert.dismiss(animated: true, completion: nil) }))

        // Confirm action and logout
        logoutAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in self.logout() }))

        present(logoutAlert, animated: true, completion: nil)
    }
    
    func editPressed() {
        //TODO: implement editing screen
        print("edit pressed")
    }
    
    //MARK: Private Methods
    private func logout() {
        if let logoutError = AuthManager.logout() {
            
            // Error logging out, display alert
            let alertController = UIAlertController(title: "Logout Error", message:
                logoutError, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            present(alertController, animated: true, completion: nil)
        }
        else {
            // Go back to root view controller
            transitionToRootVC()
        }
    }
    
    private func transitionToRootVC() {
        // Make root view controller the root view
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        
        let coordinator = AuthCoordinator(navigationController: navController)
        coordinator.start()
        
        view.window?.rootViewController = navController
        view.window?.makeKeyAndVisible()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell else {
            fatalError("The dequeued cell is not an instance of SettingsTableViewCell.")
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
            editPressed()
        default:
            fatalError(Constants.Errors.settingCellError)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
