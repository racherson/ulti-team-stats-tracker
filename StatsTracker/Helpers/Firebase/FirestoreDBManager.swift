//
//  FirestoreDBManager.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import Firebase

class FirestoreDBManager {
    
    //MARK: Properties
    let uid: String
    var delegate: DatabaseManagerDelegate?
    private let root = Firestore
        .firestore()
        .collection(FirebaseKeys.CollectionPath.environment)
        .document(FirebaseKeys.CollectionPath.environment)
    
    //MARK: Initialization
    init(uid: String) {
        self.uid = uid
    }
    
    //MARK: Private methods
    private func referenceForUserPublicData() -> DocumentReference {
        return root
            .collection(FirebaseKeys.CollectionPath.users)
            .document(uid)
            .collection(FirebaseKeys.CollectionPath.publicData)
            .document(FirebaseKeys.CollectionPath.publicData)
    }
}

//MARK: DatabaseManager
extension FirestoreDBManager: DatabaseManager {
    func setData(data: [String : Any]) {
        referenceForUserPublicData().setData(data) { (error) in
            if error != nil {
                // Show error message
                self.delegate?.displayError(with: error!)
            }
        }
    }
    
    func getData() {
        referenceForUserPublicData().getDocument { (document, error) in
            if error != nil {
                self.delegate?.displayError(with: DBError.document)
                return
            }
            guard let document = document else {
                self.delegate?.displayError(with: DBError.document)
                return
            }
            
            // grab the team name and image url
            let name = document.get(Constants.UserDataModel.teamName) as? String ?? Constants.Titles.defaultTeamName
            let urlString = document.get(Constants.UserDataModel.imageURL) as? String ?? Constants.Empty.string
            let newData = [
                Constants.UserDataModel.teamName: name,
                Constants.UserDataModel.imageURL: urlString
            ]
            
            self.delegate?.newData(newData)
        }
    }
    
    func updateData(data: [String : Any]) {
        referenceForUserPublicData().updateData(data) { (error) in
            if error != nil {
                self.delegate?.displayError(with: error!)
                return
            }
            self.delegate?.newData(data)
        }
    }
}
