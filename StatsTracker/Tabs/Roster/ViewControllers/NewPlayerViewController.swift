//
//  NewPlayerViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol NewPlayerPresenterProtocol where Self: Presenter {
    func cancelPressed()
    func savePressed(model: PlayerModel)
}

class NewPlayerViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: NewPlayerPresenterProtocol!
    var saveButton: UIBarButtonItem?
    var viewModel: RolesCellViewModel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize view model for tableView data source
        viewModel = RolesCellViewModel()
        
        // Setup the size of the tableView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Connect tableView to the View Controller and View Model
        tableView.delegate = self
        tableView.dataSource = viewModel
        tableView?.allowsMultipleSelection = true
        
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .allEditingEvents)
        
        setUpButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    //MARK: Private methods
    private func setUpButtons() {
        // Add cancel button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelPressed))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        // Add save button
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.savePressed))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    //MARK: Actions
    @objc func textFieldIsNotEmpty(sender: UITextField) {
        // Validate text field is not empty
        guard let playerName = sender.text, !playerName.isEmpty else {
            self.saveButton!.isEnabled = false
            return
        }
        // Enable save button if conditions are met
        saveButton!.isEnabled = true
    }
    
    @objc func cancelPressed() {
        presenter.cancelPressed()
    }
    
    @objc func savePressed() {
        let name = nameTextField.text!
        let gender = genderSegmentedControl.selectedSegmentIndex
        let newPlayerID = UUID().uuidString
        let roles = viewModel.selectedItems.map{ $0.item.rawValue }
        let model = PlayerModel(name: name, gender: gender, id: newPlayerID, roles: roles)
        presenter.savePressed(model: model)
    }
}

//MARK: UITextFieldDelegate
extension NewPlayerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
}

//MARK: UITableViewDelegate
extension NewPlayerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 0 && indexPath.row < Roles.allCases.count {
            viewModel.items[indexPath.row].isSelected = true
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row >= 0 && indexPath.row < Roles.allCases.count {
            viewModel.items[indexPath.row].isSelected = false
        }
    }
}
