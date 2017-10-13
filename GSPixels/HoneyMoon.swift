//
//  HoneyMoon.swift
//  GSPixels
//
//  Created by Abbey Ola on 26/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit

class HoneyMoon {
    var likes: String
    var photourl: String
    var comment: String
    var location: String
    var credit: String
    
    //MARK: Initialization
    
    init?(likes: String, photourl: String, comment: String, location: String, credit: String) {
        if photourl.isEmpty {
            return nil
        }
        self.likes = likes
        self.photourl = photourl
        self.comment = comment
        self.location = location
        self.credit = credit
    }
}
