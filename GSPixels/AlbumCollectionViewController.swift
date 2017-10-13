////
////  AlbumCollectionViewController.swift
////  GSPixels
////
////  Created by Abbey Ola on 23/08/2017.
////  Copyright © 2017 massive. All rights reserved.
////
//
//import UIKit
//
//private let reuseIdentifier = "photocell"
//
//class AlbumCollectionViewController: UICollectionViewController {
//    
//    let fetch_json = "http://www.31stbridge.com/godson_project/wedding.php";
//    let baseUrl = "http://www.31stbridge.com/godson_project/uploads/"
//    
//    var photoCover = [Photo]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//
//        // Do any additional setup after loading the view.
//        getJsonFromUrl()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//    // MARK: UICollectionViewDataSource
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return photoCover.count
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
//    
//        cell.backgroundColor = UIColor.black
//        
//        let dimension = (self.view.bounds.width / 3) - 2
//        cell.image.frame.size.width = dimension
//        cell.image.frame.size.height = dimension
//        
//        let album = photoCover[indexPath.row]
//        let url = URL(string: album.photo)
//        cell.image.kf.setImage(with: url)
//    
//        return cell
//    }
//
//    // MARK: UICollectionViewDelegate
//
//    /*
//    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment this method to specify if the specified item should be selected
//    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//    
//    }
//    */
//    
////    func getJsonFromUrl(){
////        let url = URL(string: fetch_json)
////        
////        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
////            
////            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
////                if let heroeArray = jsonObj!.value(forKey: "covers") as? NSArray {
////                    for heroe in heroeArray{
////                        if let heroeDict = heroe as? NSDictionary {
////                            if let photo_group = heroeDict.value(forKey: "photo_group") as? String , let photo_url = heroeDict.value(forKey: "photo_url") {
////                                
////                                let imageUrl = self.baseUrl.appending(photo_url as! String)
////                                
////                                guard let albumCover = Photo(name: "nil" , photo: imageUrl) else {
////                                    fatalError("unable to instatiante this catelog")
////                                }
////                                self.photoCover.append(albumCover)
////                            }
////                        }
////                    }
////                }
////                
////                OperationQueue.main.addOperation({
////                    self.view.reloadInputViews()
////                })
////            }
////        }).resume()
////    }
//    
//    func getCoverPictures() {
//        
//        for photo in allPhoto{
//            if photo.isCover == "Yes"{
//                photoCover.append(photo)
//            }
//        }
//        self.view.reloadInputViews()
//    }
//
//}
