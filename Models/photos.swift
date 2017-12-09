//
//  photos.swift
//  AFSample
//
//  Created by Shadi Matter on 12/3/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import Foundation
import  SwiftyJSON

class photos:NSObject {

    var id:Int
    var url:String
    
    init?(dict : [String : JSON]){
        guard let id = dict["id"]?.toInt, let photo = dict["photo"]?.toImagePath else {return nil}
        self.id = id
        self.url = photo
    }
}
