//
//  PhotoGalleryViewController.swift
//  GSPixels
//
//  Created by Abbey Ola on 23/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoGalleryViewController: UIViewController {
    @IBOutlet weak var kolodaView: KolodaView!
    var photoCover = [Photo]()
    var startatindex = 0
    var quoteofTheday : String?
    private let helperMethod = HelperMethods()
    private let connectionManager = ConnectionManager()

    @IBOutlet weak var randomQuoteLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionManager.quoteUpdate = { [weak self] (quote: Quotes) in
            self?.showQuote(quote: quote.random)
        }
        connectionManager.getQuotes()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(PhotoGalleryViewController.revert))
        navigationItem.rightBarButtonItem?.tintColor = globaTint
        navigationItem.leftBarButtonItem?.tintColor = globaTint
    }
    
    private func showQuote(quote: String) {
        randomQuoteLabel.text = quote
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
        let firstInstance = helperMethod.firstInstance()
        if (firstInstance){
            let alert = UIAlertController(title: AppConstants.swipeCard, message: AppConstants.swipeCardInstruction, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func reloadView(_ sender: Any) {
        kolodaView.resetCurrentCardIndex()
    }
}

