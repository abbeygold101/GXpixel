//
//  Extensions.swift
//  GSPixels
//
//  Created by Abbey Ola on 12/10/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit

extension PhotoGalleryViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        self.tabBarController?.tabBar.isHidden = true
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let fullscreenViewController = storyBoard.instantiateViewController(withIdentifier: AppConstants.fullscreen) as! FullScreenViewController
        fullscreenViewController.photos = photoCover
        fullscreenViewController.index = Int(index)
        fullscreenViewController.modalPresentationStyle = .overCurrentContext
        fullscreenViewController.delegate = self as FullScreenViewControllerDelegate
        self.present(fullscreenViewController, animated: true, completion: nil)
    }
    
    func revert()  {
        kolodaView.revertAction()
    }
    
}

extension PhotoGalleryViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return photoCover.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let album = photoCover[Int(index)]
        let url = URL(string: album.photo)
        
        let thisImage = UIImageView()
        thisImage.kf.setImage(with: url)
        thisImage.contentMode = .scaleAspectFit
        
        return thisImage
    }
}

extension PhotoGalleryViewController: FullScreenViewControllerDelegate{
    func dismissed() {
        self.tabBarController?.tabBar.isHidden = false
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        dismiss(animated: true, completion: nil)
    }
}

