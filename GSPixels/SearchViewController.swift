//
//  SearchViewController.swift
//  GSPixels
//
//  Created by Abbey Ola on 06/09/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate{
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    var arrangedPhotos = [Photo]()
    var filterPhoto = [Photo]()
    let searchLabel = UILabel()
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.delegate = self
        searchbar.returnKeyType = .done
        configlabel()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterPhoto = allPhoto.filter({$0.name.capitalized.contains(searchBar.text!)})
        searchCollectionView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! PhotoCell
        cell.backgroundColor = globaTint
        
        let dimension = (self.view.bounds.width / 3) - 2
        cell.image.frame.size.width = dimension
        cell.image.frame.size.height = dimension
        
        let album = filterPhoto[indexPath.row]
        let url = URL(string: album.photo)
        cell.image.kf.setImage(with: url)
        
        
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filterPhoto.count == 0 {
            searchCollectionView.backgroundView = searchLabel
        }
        else{
            searchCollectionView.backgroundView = nil
        }
        return filterPhoto.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (self.view.bounds.width / 3) - 2
        return CGSize(width: dimension, height: dimension)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        view.endEditing(true)
        
        switch(segue.identifier ?? "") {
            case "ShowDetail":
                guard let photoGallery = segue.destination as? PhotoGalleryViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
            
                guard let selectedPhoto = sender as? PhotoCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
            
                guard let indexPath = searchCollectionView.indexPath(for: selectedPhoto) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                arrangedPhotos.removeAll()
                for index in indexPath.row...filterPhoto.count - 1{
                    arrangedPhotos.append(filterPhoto[index])
                }
                for index in 0...indexPath.row{
                    arrangedPhotos.append(filterPhoto[index])
                }
                photoGallery.photoCover = arrangedPhotos
            case "aboutus": break
            case "searchScreen": break
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
    }
    
    func configlabel() {
        searchLabel.text = "You have not enter your search keyword. This view will be reloaded as soon as you start searching"
        searchLabel.numberOfLines = 0
        searchLabel.textAlignment = .center
        searchLabel.center = self.view.center
    }
    @IBAction func ontapgesture(_ sender: Any) {
        view.endEditing(true)
    }
}
