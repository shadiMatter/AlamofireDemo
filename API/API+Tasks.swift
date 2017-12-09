//
//  API+Tasks.swift
//  AFSample
//
//  Created by Shadi Matter on 11/2/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import Foundation
import  Alamofire
import SwiftyJSON

extension API {
    class func Tasks(page:Int = 1,completion:@escaping (_ error:Error?,_ Tasks:[tasks]?, _ last_page:Int)->Void){
    
    let url = URLs.tasksUrl
        guard let api_token = helper.getToken() else {
            completion(nil,nil,page)
            return
        }
     let parameters = [
        "api_token" : api_token,
        "page":page
     
        ] as [String : Any]
    Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        .responseJSON{ response in
            switch response.result{
            case .failure(let error):
               
            completion(error,nil,page)
                 print(error)
            case .success(let value):
                let json = JSON(value)
                
                guard let tasksArr = json["data"].array else{
                    completion(nil,nil,page)
                        return
                }
                var Tasks = [tasks]()
                for data in tasksArr{
                    guard let data = data.dictionary , let task = tasks.init(dict: data) else {return} //check if it is dictionary or not
//                    let task = tasks()
//                    task.id = data["id"]?.int ?? 0
//                    task.completed = data["completed"]?.bool ?? false
//                    task.task = data["task"]?.string ?? ""
                    
                    Tasks.append(task)
                }
                let last_page = json["last_page"].int ?? page
                completion(nil, Tasks,last_page)
            }
            
        }
    }
    
    class func NewTask(newtask:tasks,completion: @escaping (_ error:Error? , _ task : tasks?)-> Void){
        
        let url = URLs.newTask
        
        guard   let api_token = helper.getToken() else {
            completion(nil,nil)
            return
        }
        let parameters = [
            "api_token" : api_token
            , "task"   : newtask.task
        ]
        
//        Alamofire.request(url, method:.post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
            switch response.result {
            case .failure(let error):
                completion(error,nil)
                print(error)
                
            case .success(let value):
                let json  = JSON(value)
                print (json)
                print("d")
                print(json["task"])
                
                guard let taskData = json["task"].dictionary ,
                    let task = tasks(dict: taskData) else {
                    completion(nil,nil)
                    return }
            //    print(json["task"])

                completion(nil,task)

            
            }
       
            
        }
    }
    
    class func deleteTask(task:tasks, completion: @escaping (_ error:Error? , _ success:Bool?) ->Void){
         let url = URLs.deleteTaskUrl
        
        guard let api_token = helper.getToken() else {return}
        let parameters = [
            "api_token":api_token
            , "task_id" : task.id
            
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error,nil)
            case .success(let vlaue):
                let json = JSON(vlaue)
                print(json)
                
                guard let status = json["status"].toInt, status == 1 else {
                    completion(nil,false)
                    return}
                completion(nil,true)
                
            }
        }
    }
    
    class func editTask(task:tasks,completion:@escaping (_ error:Error?,_ task:tasks?)->Void)
    {
     let url = URLs.editTask
        guard let api_token = helper.getToken() else {return}
        
        let parameteres = [
            "api_token" : api_token,
            "task_id":task.id,
            "task" : task.task,
            "completed":NSNumber(booleanLiteral: task.completed).intValue
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameteres, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(error,nil)
            case .success(let value):
                let json = JSON(value)
                
             guard let taskData = json["task"].dictionary,let task = tasks(dict:taskData)
                    else {
                        completion(nil,nil)
                        return
                }
                
                completion(nil, task)
                
                
            }
            
        }
    }
}
