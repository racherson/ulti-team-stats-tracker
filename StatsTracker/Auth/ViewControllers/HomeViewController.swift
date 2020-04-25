//
//  HomeViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func signUpPressed()
    func loginPressed()
}

class HomeViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    weak var delegate: HomeViewControllerDelegate?
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions
    @IBAction func signUpPressed(_ sender: UIButton) {
        delegate?.signUpPressed()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        delegate?.loginPressed()
    }
}
