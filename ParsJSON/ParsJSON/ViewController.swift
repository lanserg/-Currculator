//
//  ViewController.swift
//  ParsJSON
//
//  Created by Elena Nazarova on 23.November.19.
//  Copyright © 2019 Elena Nazarova. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration


struct branches: Decodable {
    var organizations :  [information]
    }
        struct information: Decodable {
            var id : String?
            var currencies : money?
        }
          struct money: Decodable {
                var EUR : rate?
                var RUB : rate?
                var USD : rate?
            }
               struct rate : Decodable {
                    var ask : String?
                    var bid : String?
                }


class ViewController: UIViewController {
 
   // let userDefaultData = UserDefaults.standard
    
    public class Reachability {

        class func isConnectedToNetwork() -> Bool {

            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)

            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }

            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }

            /* Only Working for WIFI
            let isReachable = flags == .reachable
            let needsConnection = flags == .connectionRequired

            return isReachable && !needsConnection
            */

            // Working for Cellular and WIFI
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            let ret = (isReachable && !needsConnection)

            return ret

        }
    }
    
// outlet ASK Group
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var USDmaxAsk: UILabel!
    @IBOutlet weak var USDaveAsk: UILabel!
    @IBOutlet weak var USDminAsk: UILabel!
    
    @IBOutlet weak var EURmaxAsk: UILabel!
    @IBOutlet weak var EURaveAsk: UILabel!
    @IBOutlet weak var EURminAsk: UILabel!
    
    
    @IBOutlet weak var RUBmaxAsk: UILabel!
    @IBOutlet weak var RUBaveAsk: UILabel!
    @IBOutlet weak var RUBminAsk: UILabel!
    
// outlet BID Group
    
    
    @IBOutlet weak var USDmaxBid: UILabel!
    @IBOutlet weak var USDaveBid: UILabel!
    @IBOutlet weak var USDminBid: UILabel!
    
 
    @IBOutlet weak var EURmaxBid: UILabel!
    @IBOutlet weak var EURaveBid: UILabel!
    @IBOutlet weak var EURminBid: UILabel!
    
   
    @IBOutlet weak var RUBmaxBid: UILabel!
    @IBOutlet weak var RUBaveBid: UILabel!
    @IBOutlet weak var RUBminBid: UILabel!
    
    
    
    @IBAction func show(_ sender: Any) {
       // self.navigationController?.popSecondViewController(animated: true)
    }
    
    var readyEA : [String] = []
    var readyEB : [String] = []
    var readyUA : [String] = []
    var readyUB : [String] = []
    var readyRA : [String] = []
    var readyRB : [String] = []
    
    var strArrayEA : [String] = []
    var strArrayEB : [String] = []
    var strArrayUA : [String] = []
    var strArrayUB : [String] = []
    var strArrayRA : [String] = []
    var strArrayRB : [String] = []
    
    var arrayEURask : [Any] = []
    var arrayEURbid : [Any] = []
    var arrayUSDask : [Any] = []
    var arrayUSDbid : [Any] = []
    var arrayRUBask : [Any] = []
    var arrayRUBbid : [Any] = []

    var tempArr : [Any] = []
    var arrayForSegue :[String] = []
    var refreshControl = UIRefreshControl()
    
    @objc func didPullToRefresh (){
           print("Refresh")
        parseData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
       }

    func parseData () {
     
         let urlString = "http://resources.finance.ua/ru/public/currency-cash.json"
         
         guard let url = URL(string: urlString) else { return }
         
         URLSession.shared.dataTask(with: url) {(data, responce, error) in
             guard let data = data else { return }
             guard error == nil else { return }
            
             do {
                 let twoBranchesCurrency = try JSONDecoder().decode(branches.self, from: data)
                     for i in twoBranchesCurrency.organizations {
                         self.arrayEURask.append([i.currencies?.EUR?.ask])
                         self.arrayEURbid.append([i.currencies?.EUR?.bid])
                         self.arrayUSDask.append([i.currencies?.USD?.ask])
                         self.arrayUSDbid.append([i.currencies?.USD?.bid])
                         self.arrayRUBask.append([i.currencies?.RUB?.ask])
                         self.arrayRUBbid.append([i.currencies?.RUB?.bid])
                     }
                 
         // EURO group
                 
                 for i in self.arrayEURask {
                     self.strArrayEA.append("\(i)")
                     }
                 for i in self.strArrayEA {
                     var z = i
                     if (z != "[nil]") {
                         let rangeEnd = z.index(z.endIndex, offsetBy: -4)..<z.endIndex
                         let rangeStart = z.startIndex ... z.index(z.startIndex, offsetBy: 10)
                         z.removeSubrange(rangeEnd)
                         z.removeSubrange(rangeStart)
                         self.readyEA.append(z)
                         }
                     }
                 var sum = 0.0
                 var max = Double(self.readyEA[self.readyEA.count - 1])!
                 var min = Double(self.readyEA[0])!
                 let arrSum = self.readyEA.count
                 for i in self.readyEA {
                     if (Double(i)! < min) {
                         min = Double(i)!
                     }
                     if (Double(i)! > max) {
                         max = Double(i)!
                     }
                     sum += Double(i)!
                 }
                 let average = round((sum / Double (arrSum)) * 100)/100
                 print(min, "\n\(round(average * 100)/100)", "\n\(max)")
                 DispatchQueue.main.async {
                 self.EURmaxAsk.text = String(max)
                 self.EURaveAsk.text = String(average)
                 self.EURminAsk.text = String(min)
                     self.arrayForSegue.append(String(average))
                 }
                 
                 for i in self.arrayEURbid {
                     self.strArrayEB.append("\(i)")
                 }
                 for i in self.strArrayEB {
                     var z = i
                     if (z != "[nil]") {
                         let rangeEnd = z.index(z.endIndex, offsetBy: -4)..<z.endIndex
                         let rangeStart = z.startIndex ... z.index(z.startIndex, offsetBy: 10)
                         z.removeSubrange(rangeEnd)
                         z.removeSubrange(rangeStart)
                         self.readyEB.append(z)
                     }
                 }
                 var sum1 = 0.0
                 var max1 = Double(self.readyEB[self.readyEB.count - 1])!
                 var min1 = Double(self.readyEB[0])!
                 let arrSum1 = self.readyEB.count
                 for i in self.readyEB {
                     if (Double(i)! < min1) {
                         min1 = Double(i)!
                     }
                     if (Double(i)! > max1) {
                         max1 = Double(i)!
                     }
                     sum1 += Double(i)!
                 }
                 let average1 = round((sum1 / Double (arrSum1)) * 100)/100
                 print(min1, "\n\(round(average1 * 100)/100)", "\n\(max1)")
                 DispatchQueue.main.async {
                     self.EURmaxBid.text = String(max1)
                     self.EURaveBid.text = String(average1)
                     self.EURminBid.text = String(min1)
                     self.arrayForSegue.append(String(average1))
                 }
                 
         // USD group
                 
                 for i in self.arrayUSDask {
                     self.strArrayUA.append("\(i)")
                 }
                 for i in self.strArrayUA {
                     var z = i
                     if (z != "[nil]") {
                         let rangeEnd = z.index(z.endIndex, offsetBy: -4)..<z.endIndex
                         let rangeStart = z.startIndex ... z.index(z.startIndex, offsetBy: 10)
                         z.removeSubrange(rangeEnd)
                         z.removeSubrange(rangeStart)
                         self.readyUA.append(z)
                     }
                 }
                 var sum2 = 0.0
                 var max2 = Double(self.readyUA[self.readyUA.count - 1])!
                 var min2 = Double(self.readyUA[0])!
                 let arrSum2 = self.readyUA.count
                 for i in self.readyUA {
                     if (Double(i)! < min2) {
                         min2 = Double(i)!
                     }
                     if (Double(i)! > max2) {
                         max2 = Double(i)!
                     }
                     sum2 += Double(i)!
                 }
                 let average2 = round((sum2 / Double (arrSum2)) * 100)/100
                 print(min2, "\n\(round(average2 * 100)/100)", "\n\(max2)")
                 DispatchQueue.main.async {
                     self.USDmaxAsk.text = String(max2)
                     self.USDaveAsk.text = String(average2)
                     self.USDminAsk.text = String(min2)
                         self.arrayForSegue.append(String(average2))
                 }
                 
                 for i in self.arrayUSDbid {
                     self.strArrayUB.append("\(i)")
                 }
                 for i in self.strArrayUB {
                     var z = i
                     if (z != "[nil]") {
                         let rangeEnd = z.index(z.endIndex, offsetBy: -4)..<z.endIndex
                         let rangeStart = z.startIndex ... z.index(z.startIndex, offsetBy: 10)
                         z.removeSubrange(rangeEnd)
                         z.removeSubrange(rangeStart)
                         self.readyUB.append(z)
                     }
                 }
                 var sum3 = 0.0
                 var max3 = Double(self.readyUB[self.readyUB.count - 1])!
                 var min3 = Double(self.readyUB[0])!
                 let arrSum3 = self.readyUB.count
                 for i in self.readyUB {
                     if (Double(i)! < min3) {
                         min3 = Double(i)!
                     }
                     if (Double(i)! > max3) {
                         max3 = Double(i)!
                     }
                     sum3 += Double(i)!
                 }
                 let average3 = round((sum3 / Double (arrSum3)) * 100)/100
                 print(min3, "\n\(round(average3 * 100)/100)", "\n\(max3)")
                 DispatchQueue.main.async {
                     self.USDmaxBid.text = String(max3)
                     self.USDaveBid.text = String(average3)
                     self.USDminBid.text = String(min3)
                         self.arrayForSegue.append(String(average3))
                 }
                 
         // RUB group
                 
                 for i in self.arrayRUBask {
                     self.strArrayRA.append("\(i)")
                 }
                 for i in self.strArrayRA {
                     var z = i
                     if (z != "[nil]") {
                         let rangeEnd = z.index(z.endIndex, offsetBy: -4)..<z.endIndex
                         let rangeStart = z.startIndex ... z.index(z.startIndex, offsetBy: 10)
                         z.removeSubrange(rangeEnd)
                         z.removeSubrange(rangeStart)
                         self.readyRA.append(z)
                     }
                 }
                 var sum4 = 0.0
                 var max4 = Double(self.readyRA[self.readyRA.count - 1])!
                 var min4 = Double(self.readyRA[0])!
                 let arrSum4 = self.readyRA.count
                 for i in self.readyRA {
                     if (Double(i)! < min4) {
                         min4 = Double(i)!
                     }
                     if (Double(i)! > max4) {
                         max4 = Double(i)!
                     }
                     sum4 += Double(i)!
                 }
                 let average4 = round((sum4 / Double (arrSum4)) * 100)/100
                 print(min4, "\n\(round(average4 * 100)/100)", "\n\(max4)")
                 DispatchQueue.main.async {
                     self.RUBmaxAsk.text = String(max4)
                     self.RUBaveAsk.text = String(average4)
                     self.RUBminAsk.text = String(min4)
                         self.arrayForSegue.append(String(average4))
                 }
                 
                 for i in self.arrayRUBbid {
                     self.strArrayRB.append("\(i)")
                 }
                 for i in self.strArrayRB {
                     var z = i
                     if (z != "[nil]") {
                         let rangeEnd = z.index(z.endIndex, offsetBy: -4)..<z.endIndex
                         let rangeStart = z.startIndex ... z.index(z.startIndex, offsetBy: 10)
                         z.removeSubrange(rangeEnd)
                         z.removeSubrange(rangeStart)
                         self.readyRB.append(z)
                     }
                 }
                 var sum5 = 0.0
                 var max5 = Double(self.readyRB[self.readyRB.count - 1])!
                 var min5 = Double(self.readyRB[0])!
                 let arrSum5 = self.readyRB.count
                 for i in self.readyRB {
                     if (Double(i)! < min5) {
                         min5 = Double(i)!
                     }
                     if (Double(i)! > max5) {
                         max5 = Double(i)!
                     }
                     sum5 += Double(i)!
                 }
                 let average5 = round((sum5 / Double (arrSum5)) * 100)/100
                 print(min5, "\n\(round(average5 * 100)/100)", "\n\(max5)")
                 DispatchQueue.main.async {
                     self.RUBmaxBid.text = String(max5)
                     self.RUBaveBid.text = String(average5)
                     self.RUBminBid.text = String(min5)
                         self.arrayForSegue.append(String(average5))
                    
                 }
                 
                 
                 } catch {
                     print(error)
                 }
             } .resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm"
            self.arrayForSegue.append(dateformat.string(from: Date()))
            UserDefaults.standard.set(self.arrayForSegue, forKey: "arr")
        }
        
    }
    // Alert after Check Internet Connection in case "NO INternet Connection"
    
    @IBOutlet weak var LBL : UILabel!
    
    
    func alertInternetConnection() {
        
    let dialogMessage = UIAlertController(title: NSLocalizedString("Нет соединения с интернетом!", comment: ""), message: NSLocalizedString("Загрузить последние доступные данные?", comment: ""), preferredStyle: .alert)

    let ok = UIAlertAction(title: NSLocalizedString("Да", comment: ""), style: .default, handler: { (action) -> Void in
        print("Ok button tapped")
        
            // DispatchQueue.main.async {
         if let arr = UserDefaults.standard.array(forKey: "arr") as? [String]{
             
            self.EURaveAsk.text = arr[0]
            self.EURaveBid.text = arr[1]
            self.USDaveAsk.text = arr[2]
            self.USDaveBid.text = arr[3]
            self.RUBaveAsk.text = arr[4]
            self.RUBaveBid.text = arr[5]
            self.LBL.textColor = .red
            self.LBL.textAlignment = .center
            self.LBL.numberOfLines = 2
            self.LBL.sizeToFit()
            self.LBL.text = "Загружены данные от \(arr[6])"
            self.arrayForSegue = arr
         } else {
            self.LBL.textColor = .red
            self.LBL.textAlignment = .center
            self.LBL.numberOfLines = 2
            self.LBL.sizeToFit()
            self.LBL.text = "Данные не доступны. Проверьте интернет соединение."
         }
  //    }
        
    })
        
    
    let cancel = UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel) { (action) -> Void in
        print("Cancel button tapped")
    }
    dialogMessage.addAction(ok)
    dialogMessage.addAction(cancel)
    
    
    
    self.present(dialogMessage, animated: true, completion: nil)
}

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.appBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc func appBecomeActive () {
               if Reachability.isConnectedToNetwork(){
                           print("Internet Connection Available!")
                           parseData()
                       print("Updated")
                       } else {
                           print("Internet Connection not Available!")
                           alertInternetConnection()
                       }
                 
                 }
    
   
    
override func viewDidLoad() {
    super.viewDidLoad()
  /*
    NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil )
   */
    scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 400)
    scrollView.translatesAutoresizingMaskIntoConstraints = true
    scrollView.alwaysBounceVertical = true
    scrollView.bounces  = true
    scrollView.isScrollEnabled = true
    refreshControl = UIRefreshControl()
    refreshControl.tintColor = .black
    refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    scrollView.addSubview(refreshControl)
    
    
    if Reachability.isConnectedToNetwork(){
              print("Internet Connection Available!")
              parseData()
        //userDefaultData.set(arrayForSegue, forKey: "LASTDATA")
          } else {
              print("Internet Connection not Available!")
              alertInternetConnection()
          }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
              if (arrayForSegue.count > 0) {
           let destVCdata: SecondViewController = segue.destination as! SecondViewController
           destVCdata.arrayOfData = arrayForSegue
        }
    }
  /*
      override func viewWillAppear(_ animated: Bool) {
           super.viewDidLoad()
           self.navigationController?.navigationBar.isHidden = true
     
       }
  */
       override func viewWillDisappear(_ animated: Bool) {
           self.navigationController?.navigationBar.isHidden = false
       }
    
    
    
}

// 
