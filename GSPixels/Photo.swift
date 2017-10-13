//
//  Photo.swift
//  GSPixels
//
//  Created by Abbey Ola on 07/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit

struct Photo{
    
    var name: String
    var photo: String
    var tag: String
    var isCover: String
    
    //MARK: Initialization
    
    init?(name: String, photo: String, tag: String, isCover: String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
        self.photo = photo
        self.tag = tag
        self.isCover = isCover
    }
}
