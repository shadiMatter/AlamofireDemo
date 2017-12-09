//
//  helper.swift
//  AFSample
//
//  Created by Shadi Matter on 10/31/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import UIKit

class helper: NSObject {
    
    class func appRestart() {
        guard let window = UIApplication.shared.keyWindow else { return }  // main window for app
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc:UIViewController
        if helper.getToken() == nil{
            // go to auth screen
            vc = sb.instantiateInitialViewController()!
        }
        else {
            //go to main screen
            vc = sb.instantiateViewController(withIdentifier: "main")
        }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
    }
    // Save api_token to user Default
    class func saveToken(token:String){
        let def = UserDefaults.standard
        def.setValue(token, forKey: "api_token")
    def.synchronize()
        
        appRestart()
    }
    
    class func getToken()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "api_token") as? String
        
    }

}
