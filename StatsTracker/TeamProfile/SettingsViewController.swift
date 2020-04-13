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
        
        //TODO: Add an "are you sure?" alert
        
        if let logoutError = AuthManager.logout() {
            
            // Error logging out, display alert
            let alertController = UIAlertController(title: "Logout Error", message:
                logoutError, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
        }
        else {
            // Go back to root view controller
            transitionToRootVC()
        }
    }
    
    func editPressed() {
        //TODO: implement editing screen
        print("edit pressed")
    }
    
    //MARK: Private Methods
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
            fatalError("Couldn't cast to settings cell.")
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
    }
    
}
