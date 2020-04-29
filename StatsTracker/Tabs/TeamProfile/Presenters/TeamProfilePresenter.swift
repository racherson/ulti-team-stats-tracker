//
//  TeamProfilePresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import Kingfisher

protocol TeamProfilePresenterDelegate: AnyObject {
    func settingsPressed(vm: TeamProfileViewModel)
}

class TeamProfilePresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: TeamProfilePresenterDelegate?
    weak var vc: TeamProfileViewController?
    let authManager: AuthenticationManager
    var viewModel: TeamProfileViewModel? {
        didSet {
            self.onViewWillAppear()
        }
    }
    
    //MARK: Initialization
    init(vc: TeamProfileViewController, delegate: TeamProfilePresenterDelegate?, authManager: AuthenticationManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
        
        initializeViewModel()
    }
    
    //MARK: Private methods
    private func initializeViewModel() {
        // Get the current user uid
        guard let uid = authManager.currentUserUID else {
            fatalError(Constants.Errors.userError)
        }
        FirestoreReferenceManager.referenceForUserPublicData(uid: uid).getDocument { (document, error) in
            if error != nil {
                fatalError(Constants.Errors.documentError)
            }
            guard let document = document else {
                fatalError(Constants.Errors.documentError)
            }
            
            // grab the team name and image url
            let name = document.get(Constants.UserDataModel.teamName) as? String ?? Constants.Titles.defaultTeamName
            let urlString = document.get(Constants.UserDataModel.imageURL) as? String ?? Constants.Empty.string
            
            self.setViewModel(urlString: urlString, name: name)
        }
    }
    
    private func setViewModel(urlString: String, name: String) {
        // Use url string to get true url
        guard let url = URL(string: urlString) else {
            self.viewModel = TeamProfileViewModel(team: name, image: UIImage(named: Constants.Empty.image)!)
            return
        }

        // Retrieve the image from the url
        KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: url), options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self.viewModel = TeamProfileViewModel(team: name, image: value.image)
            case .failure( _):
                self.viewModel = TeamProfileViewModel(team: name, image: UIImage(named: Constants.Empty.image)!)
            }
        }
    }
}

//MARK: TeamProfilePresenterProtocol
extension TeamProfilePresenter: TeamProfilePresenterProtocol {
    func onViewWillAppear() {
        if viewModel == nil {
            // Start loading state
            vc?.loadingState()
        }
        else {
            // Give view controller new view model
            vc?.updateWithViewModel(viewModel: viewModel!)
        }
    }
    
    func settingsPressed() {
        delegate?.settingsPressed(vm: viewModel!)
    }
}
