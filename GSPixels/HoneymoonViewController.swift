//
//  HoneymoonViewController.swift
//  GSPixels
//
//  Created by Abbey Ola on 12/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit
import Kingfisher

class HoneymoonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HoneyMoonTBCellDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let cover_pictures = AppConstants.honeyMoonUrl;
    let baseUrl = AppConstants.honeymoonBaseUrl
    var honeymoonPics = [HoneyMoon]()
    var filterPhoto = [HoneyMoon]()
    let unloved = #imageLiteral(resourceName: "emptyheart")
    let loved = #imageLiteral(resourceName: "solidheart")
    var lovedpixel = [String]()
    
    @IBOutlet weak var hmTableView: UITableView!
    
    var isSearching = false
    let sanitizer = StringSanitizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedPixels = UserDefaults.standard.object(forKey: AppConstants.lovepixels) as? [String]{
            lovedpixel = savedPixels
        }
        hmTableView.estimatedRowHeight = 300
        searchBar.delegate = self
        searchBar.returnKeyType = .done
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getJsonFromUrl()
    }
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filterPhoto.count
        }
        
        return honeymoonPics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = AppConstants.honeymoonCell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HoneyMoonTableViewCell else{
            fatalError(AppConstants.fatalError)
        }
        cell.delegate = self
        var photo: HoneyMoon!
        
        if isSearching {
            photo = filterPhoto[indexPath.row]
        }else{
            photo = honeymoonPics[indexPath.row]
        }
        
        let url = URL(string: photo.photourl)
        cell.photoFrame.kf.setImage(with: url)
        cell.numberofLikesLabel.text = "\(photo.likes) people loved this"
        cell.locationLabel.text = "Location:  \(sanitizer.addSpecialCharacter(this: photo.location))"
        cell.photoCreditLabel.text = "Credit:  \(sanitizer.addSpecialCharacter(this: photo.credit))"
        cell.commentLabel.text = sanitizer.addSpecialCharacter(this: photo.comment)
        
        for comments in lovedpixel{
            if comments == cell.commentLabel.text{
                cell.lovebutton.setImage(loved, for: .normal)
                return cell
            }
            else{
                cell.lovebutton.setImage(unloved, for: .normal)
            }
        }
        
        return cell
    }
    
    func didLovePhoto(cell: HoneyMoonTableViewCell)  {
        
        let image  = cell.lovebutton.imageView?.image
        
        if (image == unloved){
            cell.lovebutton.setImage(loved, for: .normal)
            var likeCount = cell.numberofLikesLabel.text!.components(separatedBy: " ")
            let increasedLike = Int(likeCount[0])! + 1
            cell.numberofLikesLabel.text = "\(increasedLike) people loved this"
            
            let lovethis = cell.commentLabel.text
            lovedpixel.append(lovethis!)
            UserDefaults.standard.set(lovedpixel, forKey: AppConstants.lovepixels)
            UserDefaults.standard.synchronize()
        }
        else{
            return
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            hmTableView.reloadData()
        }
        else{
            isSearching = true
            // TODO: change comment to phot credit
            filterPhoto = honeymoonPics.filter({$0.credit.capitalized.contains(searchBar.text!) || $0.location.capitalized.contains(searchBar.text!)})
            hmTableView.reloadData()
        }
    }
    
    // MArk: fetch data
    func getJsonFromUrl(){
        let url = URL(string: cover_pictures)
        honeymoonPics.removeAll()
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                if let heroeArray = jsonObj!.value(forKey: "covers") as? NSArray {
                    for heroe in heroeArray{

                        if let albumDict = heroe as? NSDictionary {
                            if let location = albumDict.value(forKey: "location") as? String , let photo_url = albumDict.value(forKey: "imageurl") as? String, let comment = albumDict.value(forKey: "comment") as? String, let credit = albumDict.value(forKey: "credit") as? String, let likes = albumDict.value(forKey: "likes") as? String {

                                let imageUrl = self.baseUrl.appending(photo_url)
                                guard let photo = HoneyMoon(likes: likes, photourl: imageUrl
                                    , comment: comment, location: location, credit: credit)else {
                                        fatalError("unable to instatiante this catelog")
                                }
                                self.honeymoonPics.append(photo)
                            }
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    self.hmTableView.reloadData()
                })
            }
        }).resume()
    }
    @IBAction func dismissKeyboardonGesture(_ sender: Any) {
        view.endEditing(true)
    }
}
