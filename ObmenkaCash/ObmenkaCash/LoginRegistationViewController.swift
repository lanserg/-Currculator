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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
//    @IBOutlet weak var forgetPassword: UIButton!
    
    @IBOutlet weak var toRegistrationBTN: UIButton!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          email.resignFirstResponder()
          password.resignFirstResponder()
          return true
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
            
        notifiFromKeyboard()
    }

         deinit {
             removeNotifiFromKeyboard()
         }
         
         func notifiFromKeyboard () {
             
             NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
             
             NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
         }
         
         func removeNotifiFromKeyboard ()  {
                
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

            }
         
         @objc func kbWillShow (_ notification: Notification) {
             let userInfo = notification.userInfo
             let keyBoardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
             scrollView.contentOffset = CGPoint(x: 0, y: keyBoardSize.height)
             }
             
         @objc func kbWillHide () {
             scrollView.contentOffset = CGPoint.zero
                 }
        
    
    @IBAction func enterBTNAction(_ sender: UIButton) {
        let email = self.email.text!
        let password = self.password.text!
            if (!email.isEmpty && !password.isEmpty) {
                Auth.auth().signIn(withEmail: email, password: password) { ( result, error) in
                    if (error == nil) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.dismiss(animated: true, completion: nil)
                            self.modalShowBack()
                        }
                    } else {
                        print(error ?? "Wrong password or email")
                    }
                }
            } else {
                alertShow(message: "Заполните все поля")
            }
        }

    
    @IBAction func forgetButton(_ sender: UIButton) {
        showForgetVC()
    }
    
    
    func alertShow (message : String) {
      
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func modalShowBack() {
        let newVC = storyboard?.instantiateViewController(withIdentifier: "FirstVC") as! ViewController
        self.navigationController?.pushViewController(newVC, animated: true)
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        
         }
    
    func showForgetVC () {
        let newVC = storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        self.present(newVC, animated: true, completion: nil)
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
    }
}
