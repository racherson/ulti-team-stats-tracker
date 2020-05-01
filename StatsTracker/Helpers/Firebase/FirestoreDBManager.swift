//
//  FirestoreDBManager.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

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
    
    // This method adds new data to the current user's public data.
    func setData(data: [String : Any]) {
        referenceForUserPublicData().setData(data) { (error) in
            if error != nil {
                // Show error message
                self.delegate?.displayError(with: error!)
            }
        }
    }
    
    // This method retrieves the current user's public data and sends it to the delegate.
    func getData() {
        referenceForUserPublicData().getDocument { (document, error) in
            if error != nil {
                // Show error message
                self.delegate?.displayError(with: DBError.document)
                return
            }
            guard let document = document else {
                // Show error message
                self.delegate?.displayError(with: DBError.document)
                return
            }
            
            // Grab the team name and image url
            let name = document.get(Constants.UserDataModel.teamName) as? String ?? Constants.Titles.defaultTeamName
            let urlString = document.get(Constants.UserDataModel.imageURL) as? String ?? Constants.Empty.string
            
            let newData = [
                Constants.UserDataModel.teamName: name,
                Constants.UserDataModel.imageURL: urlString
            ]
            
            // Send retrieved data to delegate
            self.delegate?.newData(newData)
        }
    }
    
    // This method updates data in the database.
    func updateData(data: [String : Any]) {
        referenceForUserPublicData().updateData(data) { (error) in
            if error != nil {
                // Show error message
                self.delegate?.displayError(with: error!)
                return
            }
            // Don't need to send the data back as new data to delegate
            self.delegate?.newData(nil)
        }
    }
    
    // This method store an image in the FirebaseStorage and returns a url to the delegate.
    func storeImage(image: UIImage) {
        // Convert image to data to store
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            self.delegate?.displayError(with: DBError.unknown)
            return
        }
        
        // Store image under the current user uid
        let imageReference = Storage.storage()
            .reference()
            .child(FirebaseKeys.CollectionPath.imagesFolder)
            .child(uid)
        
        // Store the image data in storage
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                // Show error message
                self.delegate?.displayError(with: err)
                return
            }
            
            // Get the image url
            imageReference.downloadURL { (url, err) in
                if let err = err {
                    // Show error message
                    self.delegate?.displayError(with: err)
                    return
                }
                guard let url = url else {
                    // Show error message
                    self.delegate?.displayError(with: DBError.unknown)
                    return
                }
                
                let urlString = url.absoluteString
                
                // Send image url string to delegate
                self.delegate?.storeImageURL(url: urlString)
            }
        }
    }
}
