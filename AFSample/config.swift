//
//  config.swift
//  AFSample
//
//  Created by Shadi Matter on 10/30/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import Foundation

struct URLs{

    //MARK:- Main
    static let fileRoot = "http://127.0.0.1:8000/"
  static let main = "http://127.0.0.1:8000/api/v1/"
   //static let main = "http://www.elzohrytech.com/alamofire_demo/api/v1"
    
    //MARK:- Auth
    /// POST (email,password)
    static let login = main + "login"
    ///POST (name,email,password,password_confimation)
    static let register = main + "register"
    
    //MARK:- Tasks
    /// GET(api_token,page[optional],per_page[optional])
    static let tasksUrl = main + "tasks"
    //POST(api_token , task)
    static let newTask = main + "task/create"
    /// POST(api_token,task_id,task(optional),completed(optional))
    static let editTask = main + "task/edit"
    /// POST(api_token,task_id)
    static let deleteTaskUrl = main + "task/delete"
    
    //MARK:-Photo
    ///get (api_token,page[optinal],per_page[optional])
    static let photoUrl = main + "photos"
    /// post(api_token,photo[file])
    static let newPhotoUrl = main + "photo/create"
    
}
