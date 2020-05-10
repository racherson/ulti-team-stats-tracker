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
    var uid: String?
    weak var setDataDelegate: DatabaseManagerSetDataDelegate?
    weak var getDataDelegate: DatabaseManagerGetDataDelegate?
    weak var deleteDataDelegate: DatabaseManagerDeleteDataDelegate?
    weak var updateDataDelegate: DatabaseManagerUpdateDataDelegate?
    weak var storeImageDelegate: DatabaseManagerStoreImageDelegate?
    
    init(_ uid: String? = nil) {
        self.uid = uid
    }
    
    private let root = Firestore
        .firestore()
        .collection(FirebaseKeys.CollectionPath.environment)
        .document(FirebaseKeys.CollectionPath.environment)
    
    //MARK: Private methods
    private func referenceForUserPublicData(_ collection: DataCollection) -> DocumentReference {
        let publicDataRef = root
            .collection(FirebaseKeys.CollectionPath.users)
            .document(uid!)
            .collection(FirebaseKeys.CollectionPath.publicData)
            .document(FirebaseKeys.CollectionPath.publicData)
        
        switch collection {
        case .profile:
            return publicDataRef
        case .roster:
            return publicDataRef
            .collection(FirebaseKeys.CollectionPath.roster)
            .document(FirebaseKeys.CollectionPath.roster)
        }
    }
}

//MARK: DatabaseManager
extension FirestoreDBManager: DatabaseManager {
    
    // This method adds new data to the current user's public data.
    func setData(data: [String : Any], collection: DataCollection) {
        guard uid != nil else {
            self.setDataDelegate?.displayError(with: DBError.document)
            return
        }
        
        switch collection {
        case .profile:
            referenceForUserPublicData(collection).setData(data) { (error) in
                if error != nil {
                    // Show error message
                    self.setDataDelegate?.displayError(with: error!)
                }
            }
        case .roster:
            var genderCollection: String
            
            // Grab fields from data needed to store the data properly
            guard let gender = data[Constants.PlayerModel.gender] as? Int, let id = data[Constants.PlayerModel.id] as? String else {
                self.setDataDelegate?.displayError(with: DBError.model)
                return
            }
            
            switch gender {
            case Gender.women.rawValue:
                genderCollection = FirebaseKeys.CollectionPath.women
            case Gender.men.rawValue:
                genderCollection = FirebaseKeys.CollectionPath.men
            default:
                self.setDataDelegate?.displayError(with: DBError.model)
                return
            }
            
            referenceForUserPublicData(collection).collection(genderCollection).document(id).setData(data) { (error) in
                if error != nil {
                    // Show error message
                    self.setDataDelegate?.displayError(with: error!)
                    return
                }
                self.setDataDelegate?.onSuccessfulSet()
            }
        }
    }
    
    // This method retrieves the current user's public data and sends it to the delegate.
    func getData(collection: DataCollection) {
        guard uid != nil else {
            self.getDataDelegate?.displayError(with: DBError.document)
            return
        }
        
        switch collection {
        case .profile:
            getDataForProfile()
        case .roster:
            getDataForRoster()
        }
    }
    
    private func getDataForProfile() {
        
        referenceForUserPublicData(.profile).getDocument { (document, error) in
            if error != nil {
                // Show error message
                self.getDataDelegate?.displayError(with: error!)
                return
            }
            guard let document = document, document.exists else {
                // Show error message
                self.getDataDelegate?.displayError(with: DBError.document)
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
            self.getDataDelegate?.onSuccessfulGet(newData)
        }
    }
    
    private func getDataForRoster() {
        var womenArray: [[String: Any]] = [[String: Any]]()
        var menArray: [[String: Any]] = [[String: Any]]()
        
        // Get all the women players
        self.referenceForUserPublicData(.roster).collection(FirebaseKeys.CollectionPath.women).getDocuments { (snapshot, error) in
            if error != nil {
                // Show error message
                self.getDataDelegate?.displayError(with: error!)
                return
            }
            
            guard let snapshot = snapshot else {
                // Show error message
                self.getDataDelegate?.displayError(with: DBError.document)
                return
            }
            
            for document in snapshot.documents {
                womenArray.append(document.data())
            }
            
            // Get all the men players
            self.referenceForUserPublicData(.roster).collection(FirebaseKeys.CollectionPath.men).getDocuments { (snapshot, error) in
                if error != nil {
                    // Show error message
                    self.getDataDelegate?.displayError(with: error!)
                    return
                }
                
                guard let snapshot = snapshot else {
                    // Show error message
                    self.getDataDelegate?.displayError(with: DBError.document)
                    return
                }
                
                for document in snapshot.documents {
                    menArray.append(document.data())
                }
                
                let newData = [
                            FirebaseKeys.CollectionPath.women: womenArray,
                            FirebaseKeys.CollectionPath.men: menArray
                        ]
                self.getDataDelegate?.onSuccessfulGet(newData)
            }
        }
    }
    
    // This method updates data in the database.
    func updateData(data: [String : Any], collection: DataCollection) {
        guard uid != nil else {
            self.updateDataDelegate?.displayError(with: DBError.document)
            return
        }
        
        referenceForUserPublicData(collection).updateData(data) { (error) in
            if error != nil {
                // Show error message
                self.updateDataDelegate?.displayError(with: error!)
                return
            }
            // Don't need to send the data back as new data to delegate
            self.updateDataDelegate?.onSuccessfulUpdate()
        }
    }
    
    // This method deletes data from the database.
    func deleteData(data: [String: Any], collection: DataCollection) {
        
        switch collection {
        case .profile:
            return // Not implemented
        case .roster:
            var genderCollection: String
            
            // Grab fields from data needed to store the data properly
            guard let gender = data[Constants.PlayerModel.gender] as? Int, let id = data[Constants.PlayerModel.id] as? String else {
                self.deleteDataDelegate?.displayError(with: DBError.model)
                return
            }
            
            switch gender {
            case Gender.women.rawValue:
                genderCollection = FirebaseKeys.CollectionPath.women
            case Gender.men.rawValue:
                genderCollection = FirebaseKeys.CollectionPath.men
            default:
                self.deleteDataDelegate?.displayError(with: DBError.model)
                return
            }
            
            referenceForUserPublicData(collection).collection(genderCollection).document(id).delete() { err in
                if let err = err {
                    self.deleteDataDelegate?.displayError(with: err)
                }
                //TODO: OnSuccessfulDelete()???
            }
        }
    }
    
    // This method store an image in the FirebaseStorage and returns a url to the delegate.
    func storeImage(image: UIImage) {
        // Convert image to data to store
        guard let uid = uid, let data = image.jpegData(compressionQuality: 1.0) else {
            self.storeImageDelegate?.displayError(with: DBError.document)
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
                self.storeImageDelegate?.displayError(with: err)
                return
            }
            
            // Get the image url
            imageReference.downloadURL { (url, err) in
                if let err = err {
                    // Show error message
                    self.storeImageDelegate?.displayError(with: err)
                    return
                }
                guard let url = url else {
                    // Show error message
                    self.storeImageDelegate?.displayError(with: DBError.unknown)
                    return
                }
                
                let urlString = url.absoluteString
                
                // Send image url string to delegate
                self.storeImageDelegate?.storeImageURL(url: urlString)
            }
        }
    }
}
