//
//  ViewController.swift
//  AdminReceiptGenerator
//
//  Created by Artem Misesin on 5/6/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class ReceiptItem: MenuItem {
    var quantity: Int = Int()
    
    var total: Double{
        get{
            return price * Double(quantity)
        }
    }
}

class MenuItem {
    var name: String = String()
    var price: Double = Double()
}

protocol OrderDelegate {
    func sendDataBack(menuItems: [MenuItem]);
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource, OrderDelegate{
    
    func sendDataBack(menuItems: [MenuItem]){
        for menuItem in menuItems{
            let newItem = ReceiptItem()
            newItem.name = menuItem.name
            newItem.price = menuItem.price
            newItem.quantity = 1
            order.insert(newItem, at: 0)
        }
    }
    
//    func incrementor(value: Int, sender: ItemTableViewCell) {
//        order[order.count - sender.tag - 1].quantity = value
//        totalSumm = 0
//        
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemTableViewCell
        cell.receiptItem = order[indexPath.row]
        cell.parent = self
        cell.tag = indexPath.row
        let price = order[indexPath.row].price
        cell.textLabel?.text = order[indexPath.row].name
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.string(from: price as NSNumber) {
            cell.detailTextLabel?.text = formattedAmount.replacingOccurrences(of: "UAH", with: "₴")
        }
        totalSumm += order[indexPath.row].total
        cell.backgroundColor = Colors.settingsMainTint
        cell.textLabel?.textColor = Colors.settingsText
        cell.detailTextLabel?.textColor = Colors.settingsText
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.totalSumm -= Double(self.order[indexPath.row].quantity) * self.order[indexPath.row].price
            self.order.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        }
        
        return [delete]
    }

}

class OrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var totalAmount: UILabel!
    
    var totalSumm: Double = 0{
        didSet{
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let formattedAmount = formatter.string(from: totalSumm as NSNumber) {
                totalAmount.text = formattedAmount.replacingOccurrences(of: "UAH", with: "₴")
            }
        }
    }
    
    var order: [ReceiptItem] = []
    
    var jsonData: String?
    
    @IBAction func createOrder() {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        var jsonDict: [String: [String: Any]] = [:]
        for item in order{
            let key = item.name.lowercased().replacingOccurrences(of: " ", with: "_") + "_id"
            jsonDict[key] = [:]
            var tempDict: [String: Any] = ["name": item.name, "price":item.price.roundTo(places: 2), "quantity": item.quantity]
            jsonDict[key]! = tempDict
        }
        
        do {
            let jsonDATA = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions()) as Data
           jsonData = String(data: jsonDATA, encoding: String.Encoding.utf8) as String!
            
        } catch _ {
            print ("JSON Failure")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalSumm = 0
        
        navigationController?.navigationBar.barTintColor = Colors.barColor
        bottomBar.backgroundColor = Colors.bottomBar
        totalAmount.sizeToFit()
        self.tableView.backgroundColor = Colors.mainBackground
        self.view.backgroundColor = Colors.mainBackground
        self.navigationController?.navigationBar.tintColor = Colors.deleteColor;
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        totalSumm = 0
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMenu"{
            if let destination = segue.destination as? MenuTableViewController{
                destination.delegate = self
            }
        } else if segue.identifier == "toQR"{
            if let destination = segue.destination as? QRViewController{
                print("segue + " + jsonData!)
                destination.data = jsonData!
            }
        }
    }
    

}

