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
    func savePressed(vm: PlayerViewModel)
}

class NewPlayerViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: NewPlayerPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.savePressed))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    //MARK: Actions
    @objc func cancelPressed() {
        presenter.cancelPressed()
    }
    
    @objc func savePressed() {
        let vm = PlayerViewModel(name: "from text", gender: .women)
        presenter.savePressed(vm: vm)
    }
}
