//
//  ConnectionManager.swift
//  GSPixels
//
//  Created by Abbey Ola on 12/10/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class ConnectionManager: NSObject {
    
    var quoteUpdate: ((_ quote: Quotes) -> Void)?
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func getQuotes() {
        let url = URL(string: AppConstants.quotesUrl)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                if let quotesArray = jsonObj!.value(forKey: AppConstants.quote) as? NSArray {
                    for quote in quotesArray{
                        if let quoteDict = quote as? NSDictionary {
                            if let weddingQuote = quoteDict.value(forKey: AppConstants.wedding) as? String , let engagementQuote = quoteDict.value(forKey: AppConstants.engagement) as? String , let randomQuote = quoteDict.value(forKey: AppConstants.random) as? String{
                                self.quoteUpdate?(wedding: weddingQuote ,engagement: engagementQuote,random: randomQuote)
                            }
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                })
            }
        }).resume()
    }
}
