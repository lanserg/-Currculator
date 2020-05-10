//
//  OrderDetailsViewController.swift
//  ParsJSON
//
//  Created by Андрей Левченко on 08.03.2020.
//  Copyright © 2020 Elena Nazarova. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var showNumberOutlet: UIButton!
    
    @IBOutlet weak var callBtn: UIButton!
    
    
    @IBOutlet weak var allUserOrders: UIButton!
    
    
    var receivedData : [String] = []
    
//    var arrayOfRates : [String] = []
//
//    var arrayOfOrders : [Any] = []
    
    var arrayOfRates = UserDefaults.standard.array(forKey: "arr")

    var arrayOfOrders = UserDefaults.standard.array(forKey: "orders")

     var allUserOrd : [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        
//        print(receivedData)
        showDetails(type : true)
        callBtn.isHidden = true
//        print(arrayOfRates)
    }
    
    
    @IBAction func allUserOrdersAction(_ sender: UIButton) {
        
        for i in arrayOfOrders as! [Array<Any>] {
            if (i[8] as! String == receivedData[8]) {
                allUserOrd.append(i as! [String])
            }
        }
        
        let newVC = storyboard?.instantiateViewController(withIdentifier: "AllUserOrdersViewController") as! AllUserOrdersViewController
        self.navigationController?.pushViewController(newVC, animated: true)
        
        newVC.allUserOrder = allUserOrd
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
    }
    
    @IBAction func toCalcButton(_ sender: UIButton) {
        let newVC = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondViewController
        self.navigationController?.pushViewController(newVC, animated: true)
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        
//        newVC.arrayOfData = arrayOfRates
    }
    
    @IBAction func showNumberAction(_ sender: UIButton) {
        showDetails(type: false)
        callBtn.isHidden = false
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        self.makeAPhoneCall()
    }
    
    func makeAPhoneCall()  {
              let url: NSURL = URL(string: "TEL://\(receivedData[7])")! as NSURL
              UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
          }
    
    func showDetails (type: Bool) {
        if (receivedData.isEmpty == false) {
            if (type == true) {
            label.text = "\(receivedData[1])\n\(receivedData[0]) \(receivedData[4]) \(receivedData[2])\nпо курсу \(receivedData[3])\n(средний курс: \(averageRate()))\nКомментарий:\n\(receivedData[5])\nДата: \(receivedData[9])\n\(receivedData[6])"
            } else {
                label.text = "\(receivedData[1])\n\(receivedData[0]) \(receivedData[4]) \(receivedData[2])\nпо курсу \(receivedData[3])\n(средний курс: \(averageRate()))\nКомментарий:\n\(receivedData[5])\nДата: \(receivedData[9])\n\(receivedData[6])\n\(receivedData[7])"
            }
            }
        }

    func averageRate () -> String {
        var ave = ""
        if (receivedData[0] == "Продам" && receivedData[2] == "USD") {
            ave = arrayOfRates![2] as! String
        } else if (receivedData[0] == "Продам" && receivedData[2] == "EUR") {
            ave = arrayOfRates![0] as! String
        } else if (receivedData[0] == "Продам" && receivedData[2] == "RUB") {
            ave = arrayOfRates![4] as! String
        } else if (receivedData[0] == "Куплю" && receivedData[2] == "USD") {
            ave = arrayOfRates![3] as! String
        } else if (receivedData[0] == "Куплю" && receivedData[2] == "EUR") {
            ave = arrayOfRates![1] as! String
        } else if (receivedData[0] == "Куплю" && receivedData[2] == "RUB") {
            ave = arrayOfRates![5] as! String
        }
        return ave
    }
    
    
}
