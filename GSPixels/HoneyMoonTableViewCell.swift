//
//  HoneyMoonTableViewCell.swift
//  GSPixels
//
//  Created by Abbey Ola on 26/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit

protocol HoneyMoonTBCellDelegate {
    func didLovePhoto(cell: HoneyMoonTableViewCell)
}

class HoneyMoonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lovebutton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var numberofLikesLabel: UILabel!
    @IBOutlet weak var loveIconImageView: UIImageView!
    @IBOutlet weak var photoCreditLabel: UILabel!
    @IBOutlet weak var photoFrame: UIImageView!
    
    var delegate: HoneyMoonTBCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func didLovePhoto(_ sender: Any) {
        if let _ = delegate{
            delegate?.didLovePhoto(cell: self)
        }
    }
}
