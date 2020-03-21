//
//  LoginRegistationViewController.swift
//  ParsJSON
//
//  Created by Андрей Левченко on 29.02.2020.
//  Copyright © 2020 Elena Nazarova. All rights reserved.
//

import UIKit
import Firebase

class LoginRegistationViewController: UIViewController {
    
    var window: UIWindow?
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var forgetPassword: UIButton!
    
    @IBOutlet weak var toRegistrationBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func enterBTNAction(_ sender: UIButton) {
        let email = self.email.text!
        let password = self.password.text!
        
            if (!email.isEmpty && !password.isEmpty) {
                Auth.auth().signIn(withEmail: email, password: password) { ( result, error) in
                    if (error == nil) {
                        self.dismiss(animated: true, completion: nil)
                        self.modalShow()
                    } else {
                        print(error ?? "Wrong password or email")
                    }
                }
            } else {
                alertShow(message: "Заполните все поля")
            }
        }
    
    func alertShow (message : String) {
      
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func modalShow() {
//             let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//             let newVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//             self.window?.rootViewController?.present(newVC, animated: false, completion: nil)
        
        let newVC = storyboard?.instantiateViewController(withIdentifier: "FirstVC") as! ViewController
        self.navigationController?.pushViewController(newVC, animated: true)
         }
    
    
}
