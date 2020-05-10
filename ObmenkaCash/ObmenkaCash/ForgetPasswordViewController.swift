//
//  ForgetPasswordViewController.swift
//  ObmenkaCash
//
//  Created by Андрей Левченко on 22.03.2020.
//  Copyright © 2020 Elena Nazarova. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func resetButton(_ sender: UIButton) {
        if (textField.text!.isEmpty == false) {
            let alert = UIAlertController(title: "Сброс пароля", message: "На указанный адрес отправлено письмо с инструкциями для смены пароля", preferredStyle: .alert)
            
                      let cancel = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler:  { (action) -> Void in
//                            self.toLoginViewController()
                        let email = self.textField.text!
                         if (email.isEmpty == false) {
                             Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                                 if (error == nil) {
                                     self.dismiss(animated: true, completion: nil)
                                 }
                             }
                         }
                        
                        
                            self.dismiss(animated: true, completion: nil)
                         })
                         
                         alert.addAction(cancel)
                         self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func toLoginViewController () {
        let newVC = storyboard?.instantiateViewController(withIdentifier: "LoginRegistationViewController") as! LoginRegistationViewController
        self.present(newVC, animated: true, completion: nil)
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

}
