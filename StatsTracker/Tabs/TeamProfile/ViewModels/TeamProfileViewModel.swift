//
//  TeamProfileViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/16/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class TeamProfileViewModel {
    var teamName: String
    var teamImage: UIImage
    var email: String
    
    required init(team: String, email: String, image: UIImage) {
        self.teamName = team
        self.email = email
        self.teamImage = image
    }
    
    convenience init?(team: String, email: String, urlString: String) {
        var image: UIImage?
        let url = NSURL(string: urlString)! as URL
        
        if let imageData: NSData = NSData(contentsOf: url) {
            image = UIImage(data: imageData as Data)
        }
        else {
            image = UIImage(named: Constants.Empty.image)
        }
        
        self.init(team: team, email: email, image: image!)
    }
    
    convenience init?(model: UserDataModel) {
        self.init(team: model.teamName, email: model.email, urlString: model.imageURL)
    }
}
