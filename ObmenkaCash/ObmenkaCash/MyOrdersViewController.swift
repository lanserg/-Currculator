//
//  MyOrdersViewController.swift
//  ObmenkaCash
//
//  Created by Андрей Левченко on 08.04.2020.
//  Copyright © 2020 Elena Nazarova. All rights reserved.
//

import UIKit
import Firebase

class MyOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db = Firestore.firestore()
    
    var arrayOfOrders = UserDefaults.standard.array(forKey: "orders")
       
    var myOrders : [[String]] = []
    
    let images : [UIImage] = [UIImage(named: "usd.png")!, UIImage(named: "eur.png")!, UIImage(named: "rub.png")!]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
               if (myOrders.isEmpty == false) {
               let cellNumber = myOrders[indexPath.row]
               if (cellNumber[2] == "USD") {
               cell.imageView?.image = images[0]
               cell.textLabel?.text = "\(cellNumber[0]) \(cellNumber[4]) USD, курс \(cellNumber[3])"
               cell.detailTextLabel?.text = "\(cellNumber[1])     \(cellNumber[9])"
               } else if (cellNumber[2] == "EUR") {
                   cell.imageView?.image = images[1]
                   cell.textLabel?.text = "\(cellNumber[0]) \(cellNumber[4]) EUR, курс \(cellNumber[3])"
                   cell.detailTextLabel?.text = "\(cellNumber[1])     \(cellNumber[9])"
               } else if (cellNumber[2] == "RUB") {
                   cell.imageView?.image = images[2]
                   cell.textLabel?.text = "\(cellNumber[0]) \(cellNumber[4]) RUB, курс \(cellNumber[3])"
                   cell.detailTextLabel?.text = "\(cellNumber[1])     \(cellNumber[9])"
               }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let row = myOrders[indexPath.row]
                if let i = myOrders.firstIndex(of: row) {
                    myOrders.remove(at: i)
                    if var array = arrayOfOrders as? [[String]] {
                        if let index = array.firstIndex(of: row) {
                            array.remove(at: index)
                        }
                    }

                    db.collection("orders").document(row[10]).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
            }

            
            tableView.reloadData()
            
            }

        }
    
    
    @IBOutlet weak var myOrdersLBL: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        
    }
    
    


}
