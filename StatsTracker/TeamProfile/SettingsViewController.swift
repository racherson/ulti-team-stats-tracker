//
//  SettingsViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/12/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, Storyboarded, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    weak var coordinator: TeamProfileCoordinator?
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Data Model
    let cellLabels = ["Logout", "Edit"]
    let cellImages = [UIImage(systemName: "arrow.turn.up.left"), UIImage(systemName: "pencil")]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect tableView to the View Controller
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set the page title
        self.title = Constants.Titles.settingsTitle
    }
    
    // MARK: Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell else {
            fatalError("Couldn't cast to settings cell.")
        }
        
        // Configure the cell
        let row = indexPath.row
        cell.cellLabel.text = cellLabels[row]
        cell.cellImage.image = cellImages[row]
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
}
