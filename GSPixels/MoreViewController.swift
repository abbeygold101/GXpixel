//
//  MoreViewController.swift
//  GSPixels
//
//  Created by Abbey Ola on 12/08/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit
import MessageUI

class MoreViewController: UIViewController, MFMailComposeViewControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "goldBlack")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        imageView.frame = CGRect(x: 0, y: 0, width: 0, height: 70)
        self.navigationItem.titleView = imageView
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "phone-call"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(callUs), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        navigationItem.rightBarButtonItem?.tintColor = globaTint

    }

    @IBAction func sendEmail(_ sender: Any) {
        let mailcomposer = MFMailComposeViewController()
        mailcomposer.mailComposeDelegate = self
        mailcomposer.setToRecipients(["Info@godsonstudio.co.uk"])
        mailcomposer.setSubject("Enquiry from IOS APP")
        mailcomposer.setMessageBody("Please type your message below this line", isHTML: false)
        
        if MFMailComposeViewController.canSendMail(){
            present(mailcomposer, animated: true, completion: nil)
        }
        else{
            return
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToInstagram(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://www.instagram.com/godsonstudio/")!)
    }
    @IBAction func goToTwitter(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://twitter.com/godsonstudio")!)
    }
    @IBAction func tellAFriend(_ sender: Any) {
        let message = "Check out fabulous Wedding pictures on Godson Studio"
        if let link = NSURL(string: "http://www.godsonstudio.co.uk")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    func callUs()  {
        let url = URL(string: "TEL://+447545819070")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
}
