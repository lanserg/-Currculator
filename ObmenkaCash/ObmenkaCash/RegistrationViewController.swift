//
//  RegistrationViewController.swift
//  ParsJSON
//
//  Created by Андрей Левченко on 29.02.2020.
//  Copyright © 2020 Elena Nazarova. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    @IBAction func registrationButton(_ sender: Any) {
        let email = self.email.text!
        let password = self.password.text!
        let confirmPassword = self.confirmPassword.text!
        let name = self.name.text!
        let phone = self.phone.text!
        
        if (!email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && !name.isEmpty && !phone.isEmpty) {
            if (password == confirmPassword) {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if (error == nil){
                          if let result = result {
                                print(result.user.uid)
                           let refernce = Database.database().reference().child("users")
                            refernce.child(result.user.uid).updateChildValues(["userID" : result.user.uid, "name" : name, "email" : email, "phone" : phone])
                            self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            print(error as Any)
                        }
                    }
            }
            alertShow(message: "Пароли не совпадают")
        }
        alertShow(message: "Заполните все поля")
    }
    
    func alertShow (message : String) {
        
          let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
