//
//  NewPlayerViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol NewPlayerPresenterProtocol {
    func onViewWillAppear()
    func cancelPressed()
    func savePressed(model: PlayerModel)
}

class NewPlayerViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: NewPlayerPresenterProtocol!
    var saveButton: UIBarButtonItem?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .allEditingEvents)
        
        setUpButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func setUpButtons() {
        // Add cancel button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelPressed))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        // Add save button
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.savePressed))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    //MARK: Actions
    @objc func textFieldIsNotEmpty(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        // Validate text field is not empty
        guard let playerName = nameTextField.text, !playerName.isEmpty else {
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
        guard let name = nameTextField.text, let gender = Gender(rawValue: genderSegmentedControl.selectedSegmentIndex) else {
            //TODO: Display error
            return
        }
        
        let model = PlayerModel(name: name, gender: gender.rawValue)
        presenter.savePressed(model: model)
    }
}

//MARK: UITextFieldDelegate
extension NewPlayerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        return true
    }
}
