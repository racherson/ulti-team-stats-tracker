//
//  RootViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    weak var coordinator: AuthCoordinator?
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    @IBAction func signUpPressed(_ sender: UIButton) {
        coordinator?.signUpPressed()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        coordinator?.loginPressed()
    }

}
