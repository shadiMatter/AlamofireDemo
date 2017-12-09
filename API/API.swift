//
//  API.swift
//  AFSample
//
//  Created by Shadi Matter on 10/25/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class API: NSObject {
    
    
    class func Login(email:String,password:String,completion:@escaping (_ error:Error?, _ success:Bool)->Void){
        let url = URLs.login
        let parameters = ["email":email,"password":password]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).responseJSON
            { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error,false)
                    print(error)
                case .success(let value):
                    let json = JSON(value)
                    let api_token = json["user"]["api_token"].string
                    
            //        print("api_token:\(api_token)")
                    helper.saveToken(token: api_token!)

                    completion(nil,true)
                }
        }
        
    }
    
    class func Register(name:String,email:String,password:String,completion:@escaping (_ error:Error?, _ success:Bool)->Void){
        let url = URLs.register
        let parameters = ["name":name,"email":email,"password":password,"password_confirmation":password]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).responseJSON
            { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error,false)
                    print(error)
                case .success(let value):
                    let json = JSON(value)
                    let api_token = json["user"]["api_token"].string
                    
                    print("api_token:\(api_token)")
                    helper.saveToken(token: api_token!)

                    completion(nil,true)
                }
        }
        
    }


}
