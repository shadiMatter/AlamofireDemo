//
//  tasks.swift
//  AFSample
//
//  Created by Shadi Matter on 11/2/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import UIKit
import SwiftyJSON
class tasks: NSObject ,NSCopying {
    
    var id:Int
    var task:String
    var completed: Bool = false
    var created_at = ""
    
    init(id:Int  = 0, title:String){
        self.id = id
        self.task = title
    }
    func copy(with zone: NSZone? = nil) -> Any {
        let copiedTask = tasks(id: self.id, title: self.task)
       copiedTask.completed = self.completed
        copiedTask.created_at = self.created_at
        return copiedTask
    }
    
    init?(dict: [String :  JSON]){
        guard  let id =  dict["id"]?.toInt , 
            let task = dict["task"]?.string  else {
            return nil
        }
        self.id = id
        self.task = task
        self.completed = dict["completed"]?.toBool ?? false
        self.created_at = dict["created_at"]?.string ?? ""
    }

}
