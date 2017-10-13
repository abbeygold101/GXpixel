//
//  FullScreenViewController.swift
//  GSPixels
//
//  Created by Abbey Ola on 24/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit
import Kingfisher

protocol FullScreenViewControllerDelegate:class {
    func dismissed()
}

class FullScreenViewController: UIViewController {
    
    var delegate: FullScreenViewControllerDelegate?
    var photos = [Photo]()
    var index: Int?

    @IBOutlet weak var photoView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        
        let url = URL(string: photos[index!].photo)
        photoView.kf.setImage(with: url)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let swipeDirections: [UISwipeGestureRecognizerDirection] = [.left , .right]
        for direction in swipeDirections {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didReceivedSwipeNotification))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
    }
    
    @objc
    private func didReceivedSwipeNotification(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if index == photos.count - 1{
                delegate?.dismissed()
                return
            }
            index? += 1
            let url = URL(string: photos[index!].photo)
            UIView.transition(with: photoView,
                              duration:0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.photoView.kf.setImage(with: url) },
                              completion: nil)
        }
        else{
            if index == 0 {
                return
            }
            index? -= 1
            let url = URL(string: photos[index!].photo)
            UIView.transition(with: photoView,
                              duration:0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.photoView.kf.setImage(with: url) },
                              completion: nil)
        }
    }

    
    @IBAction func closethisView(_ sender: Any) {
        
        delegate?.dismissed()
    }
    
    @IBOutlet weak var closeView: UIButton!
}
