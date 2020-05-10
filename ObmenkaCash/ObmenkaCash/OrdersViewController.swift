//
//  OrdersViewController.swift
//  ParsJSON
//
//  Created by Андрей Левченко on 18.02.2020.
//  Copyright © 2020 Elena Nazarova. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


class Spot {
var operation : String
var currency : String
var city : String
var amount : String
var comment : String
var rate : String
var date : String
var uid : String
var username : String
var phone : String
var documentID : String
    
    init(operation : String, currency : String, city : String, amount : String, comment: String, rate : String, date : String, uid : String, username : String, phone : String, documentID: String) {
        self.operation = operation
        self.currency = currency
        self.city = city
        self.amount = amount
        self.comment = comment
        self.rate = rate
        self.date = date
        self.uid = uid
        self.username = username
        self.phone = phone
        self.documentID = documentID
    }
    convenience init (dictionary : [String : Any]) {
        let operation = dictionary ["operation"] as! String? ?? ""
        let currency = dictionary ["currency"] as! String? ?? ""
        let city = dictionary ["city"] as! String? ?? ""
        let amount = dictionary ["amount"] as! String? ?? ""
        let comment = dictionary ["comment"] as! String? ?? ""
        let rate = dictionary ["rate"] as! String? ?? ""
        let date = dictionary ["date"] as! String? ?? ""
        let uid = dictionary ["uid"] as! String? ?? ""
        let username = dictionary ["username"] as! String? ?? ""
        let phone = dictionary ["phone"] as! String? ?? ""
        
        self.init(operation: operation, currency: currency, city: city, amount: amount, comment: comment, rate: rate, date: date, uid: uid, username: username, phone: phone, documentID: "")
    }
}



class OrdersViewController: UIViewController {
    
    var spotArray = [Spot]()
    // массив с текущими курсами валют с сайта finance.ua
    
    var arrayOfRates = UserDefaults.standard.array(forKey: "arr")
    
    // массив всех заявок из БД

    var arrayOfOrders = UserDefaults.standard.array(forKey: "orders")
    
    var searchItem = [String]()
    
    var searching = false
    
    let images : [UIImage] = [UIImage(named: "usd.png")!, UIImage(named: "eur.png")!, UIImage(named: "rub.png")!]

    let arrayOfCities = ["Винница", "Днепр", "Донецк", "Житомир", "Запорожье", "Ивано-Франковск", "Киев", "Кропивницкий", "Луганск", "Луцк", "Львов", "Николаев", "Одесса", "Полтава", "Ровно", "Симферополь", "Сумы", "Тернополь", "Ужгород", "Харьков"," Херсон", "Хмельницкий", "Черкассы", "Чернигов", "Черновцы"]
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    
    @IBOutlet weak var dollarButtonOutlet: UIButton!
    @IBOutlet weak var euroButtonOutlet: UIButton!
    @IBOutlet weak var rubleButtonOutlet: UIButton!
    
    @IBOutlet weak var hundredOutlet: UIButton!
    @IBOutlet weak var thousandOutlet: UIButton!
    @IBOutlet weak var tenThousandOutlet: UIButton!
    @IBOutlet weak var moreThanTenOutlet: UIButton!
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var smallTable: UITableView!
    
    @IBOutlet weak var ordersTable: UITableView!
    
    @IBOutlet weak var showAllOffersButton: UIButton!
    
    @IBOutlet weak var addOfferButton: UIButton!
    
    @IBOutlet weak var smallTableHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var myOrdersBtn: UIButton!
    
    
    var myOrdersArray : [[String]] = []
    
    @IBAction func toMyOrdersBtn(_ sender: UIButton) {
        
        let userID = Auth.auth().currentUser!.uid

              Auth.auth().addStateDidChangeListener { (auth, user)  in
                if user != nil {
                    for i in self.arrayOfOrders as! [Array<Any>] {
                        if (i[8] as! String == userID) {
                            self.myOrdersArray.append(i as! [String])
                        }
                    }
                    print("my orders is \n \(self.myOrdersArray)")
                    self.modalShow()
                }
            }
        }
    
    func modalShow() {
        let newVC = storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
        newVC.myOrders = myOrdersArray
        self.navigationController?.pushViewController(newVC, animated: true)
        myOrdersArray.removeAll()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.smallTableHeightConst?.constant = self.smallTable.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    var identifer = "MyCell"
    var selectedArray : [[String]] = []
    var operation : String = ""
    var currency : String = ""
    var amount : String = ""
    var city : String = ""
//    var ref: DatabaseReference!

 
    @IBAction func BuyAction(_ sender: UIButton) {
        operation = "Куплю"
        filter(mainVal: operation, val2: currency, val3: compareAmount(), val4: city, arrVal1: 0, arrVal2: 2, arrVal3: 4, arrVal4: 1)
        buyButton.isEnabled = false
        sellButton.isEnabled = true
    }

    
    @IBAction func SellAction(_ sender: UIButton) {
        operation = "Продам"
        filter(mainVal: operation, val2: currency, val3: compareAmount(), val4: city, arrVal1: 0, arrVal2: 2, arrVal3: 4, arrVal4: 1)
        buyButton.isEnabled = true
        sellButton.isEnabled = false
     }
    
    
    func filter (mainVal : String, val2 : String, val3 : Int, val4 : String, arrVal1 : Int, arrVal2 : Int, arrVal3 : Int, arrVal4 : Int) {
        if (mainVal == "" && val2 == "" && val3 == 0 && val4 == "") {
                selectedArray.removeAll()
                    for i in arrayOfOrders as! [Array<Any>] {
                                 if (i[arrVal1] as! String == mainVal) {
                                    selectedArray.append(i as! [String])
                                    ordersTable.reloadData()
                                 }
                             }
        }  else if (mainVal != "" && val2 == "" && val3 == 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                                       if (i[arrVal1] as! String == mainVal) {
                                          selectedArray.append(i as! [String])
                                          ordersTable.reloadData()
                                       }
                    }
            }  else if (mainVal == "" && val2 != "" && val3 == 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 == "" && val3 != 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                if (i[arrVal1] as! String == mainVal && (i[arrVal3] as! NSString).integerValue <= val3) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 == "" && val3 == 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 != "" && val3 == 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 == "" && val3 != 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && (i[arrVal3] as! NSString).integerValue <= val3) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 == "" && val3 == 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 != "" && val3 != 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2 && (i[arrVal3] as! NSString).integerValue <= val3) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 != "" && val3 == 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 == "" && val3 != 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && (i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 != "" && val3 != 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2 && (i[arrVal3] as! NSString).integerValue <= val3) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 == "" && val3 != 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && (i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 != "" && val3 != 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2 && (i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 != "" && val3 == 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 != "" && val3 != 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2 && (i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
        }
    }
    
    
    
    // func for filtering array by AMOUNT
    
    func filterAmount (mainVal : String, val2 : String, val3 : Int, val4 : String, arrVal1 : Int, arrVal2 : Int, arrVal3 : Int, arrVal4 : Int) {
        if (mainVal == "" && val2 == "" && val3 == 0 && val4 == "") {
                selectedArray.removeAll()
                    for i in arrayOfOrders as! [Array<Any>] {
                                 if ((i[arrVal3] as! NSString).integerValue <= val3) {
                                    selectedArray.append(i as! [String])
                                    ordersTable.reloadData()
                                 }
                             }
        }  else if (mainVal != "" && val2 == "" && val3 == 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                        if ((i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal1] as! String == mainVal) {
                                          selectedArray.append(i as! [String])
                                          ordersTable.reloadData()
                                       }
                                   }
            }  else if (mainVal == "" && val2 != "" && val3 == 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if ((i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal2] as! String == val2) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 == "" && val3 != 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                if ((i[arrVal3] as! NSString).integerValue <= val3) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 == "" && val3 == 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if ((i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 != "" && val3 == 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if ((i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 == "" && val3 != 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && (i[arrVal3] as! NSString).integerValue <= val3) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 == "" && val3 == 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if ((i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal1] as! String == mainVal && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 != "" && val3 != 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal2] as! String == val2 && (i[arrVal3] as! NSString).integerValue <= val3) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 != "" && val3 == 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if ((i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal2] as! String == val2 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 == "" && val3 != 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if ((i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 != "" && val3 != 0 && val4 == "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2 && (i[arrVal3] as! NSString).integerValue <= val3) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 == "" && val3 != 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && (i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal == "" && val2 != "" && val3 != 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2 && (i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 != "" && val3 == 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if ((i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
            }  else if (mainVal != "" && val2 != "" && val3 != 0 && val4 != "") {
        selectedArray.removeAll()
            for i in arrayOfOrders as! [Array<Any>] {
                         if (i[arrVal1] as! String == mainVal && i[arrVal2] as! String == val2 && (i[arrVal3] as! NSString).integerValue <= val3 && i[arrVal4] as! String == val4) {
                            selectedArray.append(i as! [String])
                            ordersTable.reloadData()
                         }
                }
        }
    }
    
    
    @IBAction func USDAction(_ sender: UIButton) {
        currency = "USD"
        filter(mainVal: currency, val2: operation, val3: compareAmount(), val4: city, arrVal1: 2, arrVal2: 0, arrVal3: 4, arrVal4: 1)
        noData()
        dollarButtonOutlet.isEnabled = false
        euroButtonOutlet.isEnabled = true
        rubleButtonOutlet.isEnabled = true
    }
    
    @IBAction func RUBAction(_ sender: UIButton) {
        currency = "RUB"
        filter(mainVal: currency, val2: operation, val3: compareAmount(), val4: city, arrVal1: 2, arrVal2: 0, arrVal3: 4, arrVal4: 1)
        noData()
        dollarButtonOutlet.isEnabled = true
        euroButtonOutlet.isEnabled = true
        rubleButtonOutlet.isEnabled = false
    }
    
    @IBAction func EURAction(_ sender: UIButton) {
        currency = "EUR"
        filter(mainVal: currency, val2: operation, val3: compareAmount(), val4: city, arrVal1: 2, arrVal2: 0, arrVal3: 4, arrVal4: 1)
        noData()
        dollarButtonOutlet.isEnabled = true
        euroButtonOutlet.isEnabled = false
        rubleButtonOutlet.isEnabled = true
    }
    
    @IBAction func hundredAction(_ sender: UIButton) {
        amount = "100"
            filterAmount(mainVal: operation, val2: currency, val3: compareAmount(), val4: city, arrVal1: 0, arrVal2: 2, arrVal3: 4, arrVal4: 1)
        noData()
    }
    
    @IBAction func thousandAction(_ sender: UIButton) {
        amount = "1000"
            filterAmount(mainVal: operation, val2: currency, val3: compareAmount(), val4: city, arrVal1: 0, arrVal2: 2, arrVal3: 4, arrVal4: 1)
        noData()
    }
    
    @IBAction func tenAction(_ sender: UIButton) {
        amount = "10000"
            filterAmount(mainVal: operation, val2: currency, val3: compareAmount(), val4: city, arrVal1: 0, arrVal2: 2, arrVal3: 4, arrVal4: 1)
        noData()
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        amount = "100000"
            filterAmount(mainVal: operation, val2: currency, val3: compareAmount(), val4: city, arrVal1: 0, arrVal2: 2, arrVal3: 4, arrVal4: 1)
        noData()
    }
    
    
    @IBAction func resetFilters(_ sender: UIButton) {
        selectedArray.removeAll()
        ordersTable.reloadData()
        operation = ""
        amount = ""
        currency = ""
        city = ""
        searchBarOutlet.text = "Все города"
        dollarButtonOutlet.isEnabled = true
        euroButtonOutlet.isEnabled = true
        rubleButtonOutlet.isEnabled = true
        sellButton.isEnabled = true
        buyButton.isEnabled = true
    }
//    получаем уведомление об удалении заявки из MyOrders и удаляем его из основного массива заявок, обновляем таблицу
     var db = Firestore.firestore()
    
    var result1 : String = ""
    var result2 : String = ""
    var result3 : String = ""
    var result4 : String = ""
    var result5 : String = ""
    var result6 : String = ""
    var result7 : String = ""
    var result8 : String = ""
    var result9 : String = ""
    var result10 : String = ""
    var result11 : String = ""
    
    var tempArray : [[String]] = []
    
    func loadData (completed: @escaping () -> ()) {
        db.collection("orders").addSnapshotListener { (querySnapshot, error) in
          guard error == nil else {
            print("Error fetching document: \(error!.localizedDescription)")
            return completed()
          }
            self.tempArray = []
            for document in querySnapshot!.documents {
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
//                print(spot.date, spot.amount, spot.city)
//                self.spotArray.append(spot)
                self.tempArray.append([spot.operation, spot.city, spot.currency, spot.rate, spot.amount, spot.comment, spot.username, spot.phone, spot.uid, spot.date, spot.documentID])
                }
            print("tempArray:\n \(self.tempArray.count) \n \(self.tempArray)")
            self.arrayOfOrders = self.tempArray
            UserDefaults.standard.set(self.arrayOfOrders, forKey: "orders")
            self.ordersTable.reloadData()
        }
            

            completed()
        }
        
    
    override func viewWillAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver(self, selector: #selector(shouldReload), name: Notification.Name("NewFunctionName"), object: nil)
        loadData {
            self.ordersTable.reloadData()
            print("Data has been reload!")
        }

        
//        db.collection("orders").addSnapshotListener { documentSnapshot, error in
//            guard let snapshot = documentSnapshot else {
//                print("Error fetching snapshots: \(error!)")
//                return
//            }
//            snapshot.documentChanges.forEach { diff in
//                if (diff.type == .added) {
//                    print("New order: \(diff.document.data())")
//                }
//               else if (diff.type == .removed) {
//                    print("Removed order: \(diff.document.data())")
//                }
//            }
//
//            if (self.spotArray.isEmpty == false) {
//                self.arrayOfOrders?.append(self.spotArray[0])
//
//                self.ordersTable.reloadData()
//        }
//        }
        }
    
    @objc func shouldReload() {
//        arrayOfOrders = UserDefaults.standard.array(forKey: "orders")
//        print("count is \n \(arrayOfOrders?.count ?? 0)")
         self.ordersTable.reloadData()
        print("received Notification")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        
        Auth.auth().addStateDidChangeListener { (auth, user)  in
                         if user == nil {
                            self.myOrdersBtn.isEnabled = false
                            self.addOfferButton.isEnabled = false
                         } else {
                           self.myOrdersBtn.isEnabled = true
                            self.addOfferButton.isEnabled = true
            }
                  }

        
        print("array is \n \(arrayOfOrders as Any)")
        
        if #available(iOS 13.0, *) {
            searchBarOutlet[keyPath: \.searchTextField].font = UIFont.systemFont(ofSize: 12.0)
        } else {
            // Fallback on earlier versions
        } // font size/style in searchBar
        searchBarOutlet.text = "Все города"
        
        searchBarOutlet.searchBarStyle = .minimal
        dollarButtonOutlet.layer.cornerRadius = 22.0
        euroButtonOutlet.layer.cornerRadius = 22.0
        rubleButtonOutlet.layer.cornerRadius = 22.0
        smallTable.isHidden = true
        smallTable.layer.borderWidth = 1
        smallTable.layer.borderColor = UIColor.lightGray.cgColor

    }
    
// deinit {
//    NotificationCenter.default.removeObserver(self)
// }
    
    var selectedRowDetails : [String] = []
    
}

//

extension OrdersViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == ordersTable) {
            if (selectedArray.isEmpty == false) {
                return selectedArray.count
            } else {
                return arrayOfOrders!.count
            }
        } else {
            if searching {
                return searchItem.count
            } else {
                return arrayOfCities.count
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == ordersTable) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        if (selectedArray.isEmpty == false) {
            print("1 случай")
        var cellNumber = selectedArray[indexPath.row]
        if (cellNumber[2] == "USD") {
            let range = cellNumber[9].index(cellNumber[9].endIndex, offsetBy: -6)..<cellNumber[9].endIndex
            cellNumber[9].removeSubrange(range)
        cell.imageView?.image = images[0]
        cell.textLabel?.text = "\(cellNumber[0]) \(cellNumber[4]) USD, курс \(cellNumber[3])"
        cell.detailTextLabel?.text = "\(cellNumber[1])     \(cellNumber[9])"
        } else if (cellNumber[2] == "EUR") {
            let range = cellNumber[9].index(cellNumber[9].endIndex, offsetBy: -6)..<cellNumber[9].endIndex
            cellNumber[9].removeSubrange(range)
            cell.imageView?.image = images[1]
            cell.textLabel?.text = "\(cellNumber[0]) \(cellNumber[4]) EUR, курс \(cellNumber[3])"
            cell.detailTextLabel?.text = "\(cellNumber[1])     \(cellNumber[9])"
        } else if (cellNumber[2] == "RUB") {
            let range = cellNumber[9].index(cellNumber[9].endIndex, offsetBy: -6)..<cellNumber[9].endIndex
            cellNumber[9].removeSubrange(range)
            cell.imageView?.image = images[2]
            cell.textLabel?.text = "\(cellNumber[0]) \(cellNumber[4]) RUB, курс \(cellNumber[3])"
            cell.detailTextLabel?.text = "\(cellNumber[1])     \(cellNumber[9])"
        } else {
          ordersTable.reloadData()
            }
        } else {
            var cellNumber = arrayOfOrders? [indexPath.row] as! [String]
            print("2 случай")
                  if (cellNumber[2] == "USD") {
                      let range = cellNumber[9].index(cellNumber[9].endIndex, offsetBy: -6)..<cellNumber[9].endIndex
                      cellNumber[9].removeSubrange(range)
                  cell.imageView?.image = images[0]
                  cell.textLabel?.text = "\(cellNumber[0]) \(cellNumber[4]) USD, курс \(cellNumber[3])"
                  cell.detailTextLabel?.text = "\(cellNumber[1])     \(cellNumber[9])"
                  } else if (cellNumber[2] == "EUR") {
                    let range = cellNumber[9].index(cellNumber[9].endIndex, offsetBy: -6)..<cellNumber[9].endIndex
                    cellNumber[9].removeSubrange(range)
                      cell.imageView?.image = images[1]
                      cell.textLabel?.text = "\(cellNumber[0]) \(cellNumber[4]) EUR, курс \(cellNumber[3])"
                      cell.detailTextLabel?.text = "\(cellNumber[1])     \(cellNumber[9])"
                  } else if (cellNumber[2] == "RUB") {
                    let range = cellNumber[9].index(cellNumber[9].endIndex, offsetBy: -6)..<cellNumber[9].endIndex
                    cellNumber[9].removeSubrange(range)
                      cell.imageView?.image = images[2]
                      cell.textLabel?.text = "\(cellNumber[0]) \(cellNumber[4]) RUB, курс \(cellNumber[3])"
                      cell.detailTextLabel?.text = "\(cellNumber[1])     \(cellNumber[9])"
                  } else {
                    ordersTable.reloadData()
            }
            }
            return cell
        } else {
            if searching {
                           let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
                               cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
                                cell.textLabel?.adjustsFontSizeToFitWidth = true

                               cell.textLabel?.text = searchItem[indexPath.row]
                           return cell
                       } else {
                           let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
                               cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
                                cell.textLabel?.adjustsFontSizeToFitWidth = true
                               cell.textLabel?.text = arrayOfCities[indexPath.row]
                           return cell
                           }
                       }
        }
        
//    NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReload), name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
    
//  основная таблица ordersTable со всеми заявками, малая таблица smallTable для поиска заявок по городам
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == ordersTable) {
            let row = arrayOfOrders![indexPath.row] as! [String]
        for i in row  {
            selectedRowDetails.append(i)
          }
        let newVC = storyboard?.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.receivedData = selectedRowDetails
        selectedRowDetails.removeAll()
            
            let backItem = UIBarButtonItem()
            backItem.title = "Назад"
            navigationItem.backBarButtonItem = backItem
            
        } else {
            if searchItem.isEmpty == true {
             let row = arrayOfCities[indexPath.row]
                    searchBarOutlet.text = row
                    city = row
                filter(mainVal: city, val2: operation, val3: compareAmount(), val4: currency, arrVal1: 1, arrVal2: 0, arrVal3: 4, arrVal4: 2)
                    noData()
                   print(city)
                self.searchBarOutlet.endEditing(true)
                smallTable.isHidden = true
                } else {
                    let row = searchItem[indexPath.row]
                    searchBarOutlet.text = row
                    city = row
                filter(mainVal: city, val2: operation, val3: compareAmount(), val4: currency, arrVal1: 1, arrVal2: 0, arrVal3: 4, arrVal4: 2)
                    noData()
                   print(city)
                    self.searchBarOutlet.endEditing(true)
                    smallTable.isHidden = true
                }
        }
    }
    
//  перевод в Int значения amount для фильтра по сумме
    
    func compareAmount () -> Int {
        var char : Int
        switch amount {
        case "100":
            char = 100
        case "1000":
            char = 1000
        case "10000":
            char = 10000
        case "100000":
            char = 100000
        default:
            char = 0
        }
        return char
    }
    
//   алерт при отсутствии данных с выбранными фильтрами
    
    func alertNoData () {
        let dialogMessage = UIAlertController(title: NSLocalizedString("Данные отсутствуют", comment: ""), message: NSLocalizedString("Нет заявок с выбранными фильтрами, попробуйте изменить параметры", comment: "" ), preferredStyle: .alert)
        
        let send = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (action) -> Void in
            
            self.smallTable.isHidden = true
            self.searchBarOutlet.text = "Все города"
            self.city = ""
            self.smallTable.reloadData()
            self.searchBarOutlet.endEditing(true)
            
        })
        
        dialogMessage.addAction(send)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
//  вызов алерта при отсутствии данных по фильтру
    
    func noData() {
           if (selectedArray.isEmpty == true) {
                print ("Sorry, no data")
                alertNoData()
            }
    }
    
    
}

extension OrdersViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        smallTable.isHidden = false
        searchBarOutlet.text = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchItem = arrayOfCities.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        print("Searching")
        searching = true
        smallTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        smallTable.isHidden = true
        searchBarOutlet.text = "Все города"
        city = ""
        smallTable.reloadData()
        self.searchBarOutlet.endEditing(true)
    }
}
