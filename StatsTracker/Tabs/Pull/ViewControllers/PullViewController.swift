//
//  PullViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PullPresenterProtocol where Self: Presenter {
    func startGamePressed(gameModel: GameDataModel, wind: WindDirection, point: PointType)
}

class PullViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: PullPresenterProtocol!
    @IBOutlet weak var tournamentTextField: UITextField!
    @IBOutlet weak var opponentTextField: UITextField!
    @IBOutlet weak var offenseSegmentedControl: UISegmentedControl!
    @IBOutlet weak var windSegmentedControl: UISegmentedControl!
    @IBOutlet weak var startGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGameButton.isEnabled = false
        
        // Handle the text field’s user input through delegate callbacks.
        tournamentTextField.delegate = self
        opponentTextField.delegate = self
        tournamentTextField.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .allEditingEvents)
        opponentTextField.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .allEditingEvents)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    //MARK: Actions
    @objc func textFieldIsNotEmpty(sender: UITextField) {
        // Validate text fields are not empty
        guard let tournament = tournamentTextField.text, !tournament.isEmpty,
            let opponent = opponentTextField.text, !opponent.isEmpty
            else {
                startGameButton.isEnabled = false
                return
        }
        
        // Enable start game button if conditions are met
        startGameButton.isEnabled = true
    }
    
    @IBAction func startGamePressed(_ sender: UIButton) {
        // Text fields are not empty if button is enabled
        let model = GameDataModel(tournament: tournamentTextField.text!, opponent: opponentTextField.text!)
        
        // Create initial point of the game
        let wind = WindDirection(rawValue: windSegmentedControl.selectedSegmentIndex)!
        let point = PointType(rawValue: offenseSegmentedControl.selectedSegmentIndex)!
        
        clearForm()
        presenter.startGamePressed(gameModel: model, wind: wind, point: point)
    }
    
    //MARK: Private methods
    private func clearForm() {
        tournamentTextField.text = nil
        opponentTextField.text = nil
        windSegmentedControl.selectedSegmentIndex = 0
        offenseSegmentedControl.selectedSegmentIndex = 0
    }
}

//MARK: UITextFieldDelegate
extension PullViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
}
