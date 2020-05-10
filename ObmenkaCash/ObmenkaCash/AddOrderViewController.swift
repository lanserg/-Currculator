//
//  AddOrderViewController.swift
//  ParsJSON
//
//  Created by Андрей Левченко on 05.03.2020.
//  Copyright © 2020 Elena Nazarova. All rights reserved.
//

import UIKit
import Firebase

class AddOrderViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var searching = false
    
    var searchItem = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               if searching {
                 return searchItem.count
             } else {
                 return arrayOfCities.count
             }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        if searching {
                           cell.textLabel?.text = searchItem[indexPath.row]
                   } else {
                           cell.textLabel?.text = arrayOfCities[indexPath.row]
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             if searchItem.isEmpty == true {
          let row = arrayOfCities[indexPath.row]
             searchBar.text = row
                city = row
                print(city)
             self.searchBar.endEditing(true)
             tableView.isHidden = true
             } else {
                 let row = searchItem[indexPath.row]
                 searchBar.text = row
                    city = row
                print(city)
                 self.searchBar.endEditing(true)
                 tableView.isHidden = true
             }
    }
    
    override func viewWillLayoutSubviews() {
         super.updateViewConstraints()
         self.tableConstrait?.constant = self.tableView.contentSize.height
     }
     
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         self.viewWillLayoutSubviews()
     }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          tableView.isHidden = true
          tableView.reloadData()
          self.searchBar.endEditing(true)

      }
    
    @IBOutlet weak var tableConstrait: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var segmentBuySell: UISegmentedControl!
    
    @IBOutlet weak var USDButton: UIButton!
    @IBOutlet weak var RUBButton: UIButton!
    @IBOutlet weak var EURButton: UIButton!
    
    @IBOutlet weak var rateText: UITextField!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var sendOfferButton: UIButton!
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        print(selectOperaion())
    }
    
    let arrayOfCities = ["Винница", "Днепр", "Донецк", "Житомир", "Запорожье", "Ивано-Франковск", "Киев", "Кропивницкий", "Луганск", "Луцк", "Львов", "Николаев", "Одесса", "Полтава", "Ровно", "Симферополь", "Сумы", "Тернополь", "Ужгород", "Харьков"," Херсон", "Хмельницкий", "Черкассы", "Чернигов", "Черновцы"]
    
    var currency = ""
    var city = ""
    var amount = ""
    var rate = ""
    var comment = ""
    var orderDetailsArray : [[String]] = []
    var temporaryOrderArray : [String] = []
    
    @IBAction func EURAction(_ sender: UIButton) {
        EURButton.isEnabled = false
        USDButton.isEnabled = true
        RUBButton.isEnabled = true
        currency = "EUR"
        print(currency)
    }
    
    @IBAction func USDAction(_ sender: UIButton) {
        USDButton.isEnabled = false
        EURButton.isEnabled = true
        RUBButton.isEnabled = true
        currency = "USD"
        print(currency)
    }
    
    @IBAction func RUBAction(_ sender: UIButton) {
        RUBButton.isEnabled = false
        USDButton.isEnabled = true
        EURButton.isEnabled = true
        currency = "RUB"
        print(currency)
    }
    
    let db = Firestore.firestore()
    var ref = Database.database().reference()
    var tempID : String = ""
    
    @IBAction func sendOrder(_ sender: UIButton) {
        
        if (amountText.text?.isEmpty == false && rateText.text?.isEmpty == false && currency.isEmpty == false && city.isEmpty == false) {
        amount = amountText.text!
        rate = rateText.text!
            
            var username : String = ""
            var phone : String = ""
            
             let userID = Auth.auth().currentUser?.uid

//            let userID = Auth.auth().currentUser?.uid
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
              let value = snapshot.value as? NSDictionary
                username = value?["name"] as? String ?? ""
                phone = value?["phone"] as? String ?? ""
                self.temporaryOrderArray.append(username)
                self.temporaryOrderArray.append(phone)
                print("userName is: \(username)")
              }) { (error) in
                print(error.localizedDescription)
            }
            
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy HH:mm"
            let date = "\(dateformat.string(from: Date()))"
        
        temporaryOrderArray.append(selectOperaion())
        temporaryOrderArray.append(currency)
        temporaryOrderArray.append(city)
        temporaryOrderArray.append(amount)
        temporaryOrderArray.append(rate)
        temporaryOrderArray.append(comment)
        temporaryOrderArray.append(date)
        
        let dialogMessage = UIAlertController(title: NSLocalizedString("Все верно?", comment: ""), message: NSLocalizedString("\(currency), \(selectOperaion()), \(city), \(amount), \(rate), \(comment) ", comment: ""), preferredStyle: .alert)
        
    // ALERT при нажатии кнопки "Отправить"
            
    let send = UIAlertAction(title: NSLocalizedString("Отправить", comment: ""), style: .default, handler: { (action) -> Void in
        let dbArray : [String : Any] = [
            "operation" : self.selectOperaion(),
            "currency" : self.currency,
            "city" : self.city,
            "amount" : self.amount,
            "rate" : self.rate,
            "comment" : self.comment,
            "date" : date,
            "uid" : userID!,
            "username" : username,
            "phone" : phone
                ]
        print("Sending to DB")
        print(self.temporaryOrderArray)
//            добавляем новый документ с заявкой в бд и получаем его id
        var ref: DocumentReference? = nil
        ref = self.db.collection("orders").addDocument(data: dbArray) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
//        ref = self.db.collection("orders").document().setData(dbArray) {
//
//                      err in
//                        if let err = err {
//                            print("Error adding document: \(err)")
//                        } else {
//                            let idd = ref!.documentID
//                            print("Document added with ID: \(idd)")
//                        }
//                    }
        
//        self.db.collection("orders").document(self.uid).getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data:\n \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }

        
        
            self.orderDetailsArray.append(self.temporaryOrderArray)
            self.temporaryOrderArray.removeAll()
            self.amountText.text = ""
            self.rateText.text = ""
            self.textView.text = ""
            self.searchBar.text = ""
        self.textView.resignFirstResponder()
        self.amountText.resignFirstResponder()
        self.rateText.resignFirstResponder()
        self.USDButton.isEnabled = true
        self.EURButton.isEnabled = true
        self.RUBButton.isEnabled = true

            print(self.orderDetailsArray)
        })
             
             let cancel = UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .default, handler:  { (action) -> Void in
                 print("Cancel")
                self.temporaryOrderArray.removeAll()
                self.dismiss(animated: true, completion: nil)
             })
             
             dialogMessage.addAction(send)
             dialogMessage.addAction(cancel)
             self.present(dialogMessage, animated: true, completion: nil)

//             self.present(dialogMessage, animated: true) {
//                 dialogMessage.view.superview?.isUserInteractionEnabled = true
//                 dialogMessage.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
//             }
//        func alertControllerBackgroundTapped()
//         {
//             self.dismiss(animated: true, completion: nil)
//         }
        } else {
            let dialogMessageFail = UIAlertController(title: NSLocalizedString("Ошибка при заполнении", comment: ""), message: NSLocalizedString("Убедитесть, что выбрана валюта, город и заполнены поля \"Сумма\" и \"Курс\"", comment: ""), preferredStyle: .alert)
            
            let ok = UIAlertAction(title: NSLocalizedString("Ок", comment: ""), style: .default, handler: { (action) -> Void in
                   print("Error fill")
                   })
            
            dialogMessageFail.addAction(ok)
            self.present(dialogMessageFail, animated: true, completion: nil)
        }
    }
    
    var uid : String = ""

    // добавление placeholder "Комментарий" в UITextView поле
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            if let selectedRange = textView.selectedTextRange {
                let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
                print("\(cursorPosition)")
            let newPosition = textView.beginningOfDocument
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
            textView.text = "0"
            textView.textColor = UIColor.black
            }
        }
        }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Комментарий"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    // Убираем клавиатуру в UITextView

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

    comment = textView.text!
    
      if(text == "\n") {
          textView.resignFirstResponder()
          return false
      }
   
  
    
    if let selectedRange = textView.selectedTextRange {
        

                   let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)

                   print("\(cursorPosition)")
    }
    
        return textView.text.count + (text.count - range.length) <= 100
  }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        
        notifiFromKeyboard()
        
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.text = "Комментарий"
        textView.textColor = UIColor.lightGray
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1
//        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = .minimal
        tableView.isHidden = true
    }
   
    
    deinit {
         removeNotifiFromKeyboard()
     }
     
    
     func notifiFromKeyboard () {
         
         NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         
         NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kbHide)))
        
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
    
        @objc func kbHide () {
            scrollView.contentOffset = CGPoint.zero
            view.endEditing(true)
            }
   
    
    
    func selectOperaion () -> String {
          let select = segmentBuySell.selectedSegmentIndex
          var operation = NSLocalizedString("Куплю", comment: "")
          switch select {
          case 0:
              operation = NSLocalizedString("Куплю", comment: "")
          case 1:
             operation = NSLocalizedString("Продам", comment: "")
          default:
              print("not selected")
          }
          return (operation)
      }
    

}

extension AddOrderViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         
         searchItem = arrayOfCities.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
         searching = true
         tableView.reloadData()
     }
}

extension AddOrderViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amount = amountText.text!
        rate = rateText.text!
        
        amountText.resignFirstResponder()
        rateText.resignFirstResponder()
        
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == amountText) {
        guard let textFieldText = amountText.text,
             let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                 return false
         }
         let substringToReplace = textFieldText[rangeOfTextToReplace]
         let count = textFieldText.count - substringToReplace.count + string.count
         return count <= 7
        } else if (textField == rateText) {
            guard let textFieldText = rateText.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 7
        }
        return true
    }

}
    
    

