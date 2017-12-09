//
//  ViewController.swift
//  AFSample
//
//  Created by Shadi Matter on 9/24/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class ViewController: UIViewController {

    @IBOutlet weak var PasswordTX: UITextField!
    @IBOutlet weak var EmailTX: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

                }


    @IBAction func LoginPress(_ sender: Any) {
        guard let email = EmailTX.text, !email.isEmpty else {return }
        guard let password = PasswordTX.text ,!password.isEmpty else {return}
        
        API.Login(email: email, password: password) { (error:Error?, success:Bool) in
            if success {
                
                
            }
        }
     
        
    }
}
    


    

   

    


