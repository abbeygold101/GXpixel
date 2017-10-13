//
//  HelperMethods.swift
//  GSPixels
//
//  Created by Abbey Ola on 18/09/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class HelperMethods{
    
    func firstInstance() -> Bool {
        guard let _ = UserDefaults.standard.object(forKey: AppConstants.firstInstance) as? String else {
            UserDefaults.standard.set("done", forKey: AppConstants.firstInstance)
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask,
                                andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
