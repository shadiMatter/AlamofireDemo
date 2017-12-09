//
//  JSON+Extention.swift
//  AFSample
//
//  Created by Shadi Matter on 11/14/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    
    var toBool:Bool? {
        if let bool = self.bool {return bool}
        if let  int = self.toInt{
            if int == 0 {return false}
            else if int == 1 {return true}
        }
         return nil
    }
   
    
    var toInt : Int?{
        if let int = self.int {return int}
        if let string = self.string ,let int = Int(string) {return int}
    return nil
    }
    
    var toImagePath:String? {
        guard let photo = self.string ,!photo.isEmpty else {return nil}
        return URLs.fileRoot+photo
    }
    
   
}
