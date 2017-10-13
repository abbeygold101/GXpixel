//
//  StringSanitizer.swift
//  GSPixels
//
//  Created by Abbey Ola on 16/09/2017.
//  Copyright © 2017 massive. All rights reserved.
//

import UIKit

class StringSanitizer : NSObject{
    let andReplace = "andReplace"
    let singleQuote = "singleQuote"
    let poundSterling = "poundSterling"
    let euRO = "euRO"
    let doLLAR = "doLLAR"
    let leftbracKET = "leftbracKET"
    let rightbracKET = "rightbracKET"
    let dounbleQuote = "dounbleQuote"
    let percenTage = "percenTage"
    let backSlash = "backSlash"
    let frontSlash = "frontSlash"
    
    func cleanString(this: String) -> String {
        var newString = this.replacingOccurrences(of: "&", with: andReplace )
        newString = newString.replacingOccurrences(of: "'", with: singleQuote )
        newString = newString.replacingOccurrences(of: "£", with: poundSterling )
        newString = newString.replacingOccurrences(of: "€", with: euRO )
        newString = newString.replacingOccurrences(of: "$", with: doLLAR )
        newString = newString.replacingOccurrences(of: "(", with: leftbracKET )
        newString = newString.replacingOccurrences(of: ")", with: rightbracKET )
        newString = newString.replacingOccurrences(of: "\"", with: dounbleQuote )
        newString = newString.replacingOccurrences(of: "%", with: percenTage )
        newString = newString.replacingOccurrences(of: "/", with: backSlash )
        newString = newString.replacingOccurrences(of: "\\", with: frontSlash )
        
        return newString
    }
    
    func addSpecialCharacter(this: String) -> String {
        var newString = this.replacingOccurrences(of: andReplace, with: "&" )
        newString = newString.replacingOccurrences(of: singleQuote, with: "'" )
        newString = newString.replacingOccurrences(of: poundSterling, with: "£" )
        newString = newString.replacingOccurrences(of: euRO, with: "€" )
        newString = newString.replacingOccurrences(of: doLLAR, with: "$" )
        newString = newString.replacingOccurrences(of: leftbracKET, with: "(" )
        newString = newString.replacingOccurrences(of: rightbracKET, with: ")" )
        newString = newString.replacingOccurrences(of: dounbleQuote, with: "\"" )
        newString = newString.replacingOccurrences(of: percenTage, with: "%" )
        newString = newString.replacingOccurrences(of: backSlash, with: "/" )
        newString = newString.replacingOccurrences(of: frontSlash, with: "\\" )
        
        return newString
    }
}
