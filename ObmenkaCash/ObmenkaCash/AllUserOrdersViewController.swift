//
//  AllUserOrdersViewController.swift
//  ObmenkaCash
//
//  Created by Андрей Левченко on 05.04.2020.
//  Copyright © 2020 Elena Nazarova. All rights reserved.
//

import UIKit

class AllUserOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var label: UILabel!
    
    let images : [UIImage] = [UIImage(named: "usd.png")!, UIImage(named: "eur.png")!, UIImage(named: "rub.png")!]
    
    var allUserOrder : [[String]] = []
    
    var selectedRowDetails : [String] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return allUserOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        var cellNumber = allUserOrder[indexPath.row]
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
           }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let row = allUserOrder[indexPath.row]
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
    }
    
    let saving = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        
        label.text = "Все заявки пользователя\n \(allUserOrder[0][6])"
        
    }
    


}
