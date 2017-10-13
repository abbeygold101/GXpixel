//
//  PhotoTableViewCell.swift
//  GSPixels
//
//  Created by Abbey Ola on 07/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureFrame: UIImageView!
    
    override func awakeFromNib() {super.awakeFromNib()}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
