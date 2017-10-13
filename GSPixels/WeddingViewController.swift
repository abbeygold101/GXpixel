//
//  WeddingViewController.swift
//  GSPixels
//
//  Created by Abbey Ola on 09/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit
import Kingfisher

class WeddingViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

    @IBOutlet weak var weddingQuoteLabel: UILabel!
    @IBOutlet weak var weddingCView: UICollectionView!

    var photoCover = [Photo]()
    var arrangedPhotos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "goldBlack")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        imageView.frame = CGRect(x: 0, y: 0, width: 0, height: 70)
        self.navigationItem.titleView = imageView
        weddingQuoteLabel.text = _weddingQuote
        getWeddingPictures()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! PhotoCell
        cell.backgroundColor = globaTint

        let dimension = (self.view.bounds.width / 3) - 2
        cell.image.frame.size.width = dimension
        cell.image.frame.size.height = dimension
        
        let album = photoCover[indexPath.row]
        let url = URL(string: album.photo)
        cell.image.kf.setImage(with: url)
        
        
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCover.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (self.view.bounds.width / 3) - 2
        return CGSize(width: dimension, height: dimension)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "ShowDetail":
                guard let photoGallery = segue.destination as? PhotoGalleryViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
            
                guard let selectedPhoto = sender as? PhotoCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
            
                guard let indexPath = weddingCView.indexPath(for: selectedPhoto) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                arrangedPhotos.removeAll()
            
                for index in indexPath.row...photoCover.count - 1{
                    arrangedPhotos.append(photoCover[index])
                }
                for index in 0...indexPath.row{
                    arrangedPhotos.append(photoCover[index])
                }
                photoGallery.photoCover = arrangedPhotos
            case "aboutus": break
            case "searchScreen": break
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
    }

    func getWeddingPictures() {
        for photo in allPhoto{
            if photo.tag == "Wedding"{
                photoCover.append(photo)
            }
        }
        self.weddingCView.reloadData()
    }
}
