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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
