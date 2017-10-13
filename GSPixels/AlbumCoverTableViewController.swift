//
//  AlbumCoverTableViewController.swift
//  GSPixels
//
//  Created by Abbey Ola on 07/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

var globaTint = UIColor()
var allPhoto = [Photo]()
var photo_group = [Photo]()
var _weddingQuote = String()
var _engagementQuote = String()
var _randomeQuote = String()

class AlbumCoverTableViewController: UITableViewController {
    
    //MARK: Properties
    let cover_pictures = AppConstants.homeDirectory
    let baseUrl = AppConstants.baseUrl
    var photoCover = [Photo]()
    let helperMethod = HelperMethods()
    var alert: UIAlertController?
    private let connectionManager = ConnectionManager()
    
    @IBOutlet var albumTView: UITableView!
    @IBOutlet weak var aboutus: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (connectionManager.isInternetAvailable()){
            getJsonFromUrl()
        }
        else{
            alert = UIAlertController(title: AppConstants.noConnection, message: AppConstants.connectionErrorMessage, preferredStyle: .alert)
            alert?.addAction(UIAlertAction(title: AppConstants.dismiss, style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alert!, animated: true, completion: nil)
        }
    
        let logo = #imageLiteral(resourceName: "goldBlack")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 0, height: 70)
        self.navigationItem.titleView = imageView
        globaTint = aboutus.tintColor!
        self.tabBarController?.tabBar.tintColor = globaTint
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return photoCover.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = AppConstants.photoTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PhotoTableViewCell else{
            fatalError(AppConstants.fatalError)
        }
        
        let album = photoCover[indexPath.row]
        
        let title = album.name
        let replacementtext = title.replacingOccurrences(of: " N ", with: AppConstants.sparklingHeart )
        cell.nameLabel.text = replacementtext
        let url = URL(string: album.photo)
        cell.pictureFrame.kf.setImage(with: url)

        return cell
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case AppConstants.ShowDetail:
                guard let photoGallery = segue.destination as? PhotoGalleryViewController else {
                    fatalError("\(AppConstants.unexpectedDestination): \(segue.destination)")
                }
            
                guard let selectedAlbumCell = sender as? PhotoTableViewCell else {
                    fatalError("\(AppConstants.unexpectedDestination): \(String(describing: sender))")
                }
            
                guard let indexPath = tableView.indexPath(for: selectedAlbumCell) else {
                    fatalError(AppConstants.cellIndexError)
                }
                
                let selectedAlbum = photoCover[indexPath.row]
                getrelatedPictures(group: selectedAlbum.name)
                photoGallery.photoCover = photo_group

            case AppConstants.aboutUs: break
            case AppConstants.searchScreen: break
            default:
                fatalError("\(AppConstants.unexpectedDestination); \(String(describing: segue.identifier))")
            }
    }
    
    func getJsonFromUrl(){
        let url = URL(string: cover_pictures)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                if let albumsArray = jsonObj!.value(forKey: "covers") as? NSArray {
                    for albums in albumsArray{
                        if let albumDict = albums as? NSDictionary {
                            if let photo_group = albumDict.value(forKey: "photo_group") as? String , let photo_url = albumDict.value(forKey: "photo_url") , let photo_tag = albumDict.value(forKey: "photo_tag") as? String , let isCover = albumDict.value(forKey: "isCover") as? String {
                                
                                var photoGroup = photo_group
                                if (photoGroup == ""){
                                    photoGroup = "None"
                                }
                                    
                                let imageUrl = self.baseUrl.appending(photo_url as! String)
                                
                                guard let albumCover = Photo(name: photoGroup , photo: imageUrl, tag: photo_tag, isCover: isCover ) else {
                                    fatalError("unable to instatiante this catelog")
                                }
                                allPhoto.append(albumCover)
                            }
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    self.getCoverPictures()
                })
            }
        }).resume()
    }
    
    func getCoverPictures() {
        for photo in allPhoto{
            if photo.isCover == "Yes"{
                photoCover.append(photo)
            }
        }
        photoCover.reverse()
        self.albumTView.reloadData()
    }
    
    func getrelatedPictures(group: String) {
        photo_group.removeAll()
        for photo in allPhoto{
            if photo.name == group{
                photo_group.append(photo)
            }
        }
    }
}
