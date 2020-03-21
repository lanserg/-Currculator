//
//  OrdersViewController.swift
//  ParsJSON
//
//  Created by Андрей Левченко on 18.02.2020.
//  Copyright © 2020 Elena Nazarova. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {
    
    var arrayOfOrders : [String] = []

    
    @IBOutlet weak var dollarButtonOutlet: UIButton!
    @IBOutlet weak var euroButtonOutlet: UIButton!
    @IBOutlet weak var rubleButtonOutlet: UIButton!
    
    @IBOutlet weak var hundredOutlet: UIButton!
    @IBOutlet weak var thousandOutlet: UIButton!
    @IBOutlet weak var tenThousandOutlet: UIButton!
    @IBOutlet weak var moreThanTenOutlet: UIButton!
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    
    
    @IBOutlet weak var ordersTable: UITableView!
    
    @IBOutlet weak var showAllOffersButton: UIButton!
    
    @IBOutlet weak var addOfferButton: UIButton!
    var identifer = "MyCell"
 
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchBarOutlet.backgroundImage = UIImage()

        
//        showAllOffersButton.layer.cornerRadius = 22.0
        
        
//        hundredOutlet.layer.cornerRadius = 10
//        thousandOutlet.layer.cornerRadius = 10
//        tenThousandOutlet.layer.cornerRadius = 10
//        moreThanTenOutlet.layer.cornerRadius = 10
//
//        hundredOutlet.layer.borderWidth = 1
//        thousandOutlet.layer.borderWidth = 1
//        tenThousandOutlet.layer.borderWidth = 1
//        moreThanTenOutlet.layer.borderWidth = 1
//
//        hundredOutlet.layer.borderColor = UIColor.gray.cgColor
//        thousandOutlet.layer.borderColor = UIColor.gray.cgColor
//        tenThousandOutlet.layer.borderColor = UIColor.gray.cgColor
//        moreThanTenOutlet.layer.borderColor = UIColor.gray.cgColor

//        addOfferButton.layer.cornerRadius = 10.0
        dollarButtonOutlet.layer.cornerRadius = 22.0
        euroButtonOutlet.layer.cornerRadius = 22.0
        rubleButtonOutlet.layer.cornerRadius = 22.0

    }
 
 
    
}
extension OrdersViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath)
        let cellNumber = arrayOfOrders[indexPath.row]
        cell.textLabel?.text = cellNumber
        
        return cell
    }
    
    
}
