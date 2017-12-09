//
//  API+Photo.swift
//  AFSample
//
//  Created by Shadi Matter on 12/2/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension API{
    
    class func photo(page:Int = 1,completion:@escaping (_ error:Error?,_ photos:[photos]?, _ last_page:Int)->Void){
        let url = URLs.photoUrl
        guard let api_token = helper.getToken() else {
            completion(nil,nil,page)
            return}
        
        let parametrs = ["api_token":api_token,"page":page] as?[String:Any]
        
        Alamofire.request(url, method: .get, parameters: parametrs, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(error,nil,page)
            case .success(let value):
                let json = JSON(value)
                print(json)
                guard let photoArr = json["data"].array else {
                    completion(nil,nil,page)
                    return
                }
                
                var photoA = [photos]()
                photoArr.forEach({
                    if let dict = $0.dictionary , let photo = photos(dict: dict){
                        photoA.append(photo)
                    }
                })
                
//                for data in photoArr {
//                    guard let data = data.dictionary , let photo = photos.init(dict: data) else {return }
//                photoA.append(photo)
//                }
                let last_page = json["last_page"].toInt ?? page
                completion(nil,photoA,last_page)
           
            }
            
        }
        
    }// End photo func
    
    class func createPhoto(photo:UIImage,completion:@escaping (_ error:Error?,_ success:Bool?)->Void){
        guard let api_token = helper.getToken() else {
            completion(nil,false)
            return}
        let url = URLs.newPhotoUrl+"?api_token=\(api_token)"
        
        Alamofire.upload(multipartFormData: { (form:MultipartFormData) in
          // convert image to data
            if let data = UIImageJPEGRepresentation(photo, 0.5){
            form.append(data, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: nil) { (result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .failure(let error ):
               completion(error,false)
                print(error)
            case .success(request:let upload, streamingFromDisk: _ , streamFileURL: _):
                upload.uploadProgress(closure: {(progress:Progress ) in
                    print(progress)
                    
                }).responseJSON(completionHandler: { response in
                    switch response.result {
                    case .failure(let error):
                        completion(error,nil)
                            print(error)
                    case .success(let value):
                        let json = JSON(value)
                        if let status = json["status"].toInt , status == 1 {
                            print("Upload Succes")
                            completion(nil,true)
                        }else{
                            print("Upload Fail")
                            completion(nil,false)
                        }
                        
                    }
                })
                
            }
            
            
        }
    }
}
