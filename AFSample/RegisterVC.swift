//
//  RegisterVC.swift
//  AFSample
//
//  Created by Shadi Matter on 10/25/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var PasswordConfitmTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var NameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



        @IBAction func RegisterPressed(_ sender: Any) {
            
            guard  let name = NameTF.text?.trimmed, !name.isEmpty,
             let email = EmailTF.text?.trimmed, !email.isEmpty,
             let  password = PasswordTF.text?.trimmed, !password.isEmpty,
             let newpassword = PasswordConfitmTF.text?.trimmed, !newpassword.isEmpty
            else{return}
            
            guard password == newpassword else{return}
            
            API.Register(name: name, email: email, password: password) { (error:Error?, success:Bool) in
                if success{
                    print("Register success")
                }
            }
        
    }
    
}
