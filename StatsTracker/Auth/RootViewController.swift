//
//  RootViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol RootViewControllerDelegate {
    func signUpPressed()
    func loginPressed()
}

class RootViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var delegate: RootViewControllerDelegate?
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    @IBAction func signUpPressed(_ sender: UIButton) {
        delegate?.signUpPressed()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        delegate?.loginPressed()
    }

}
