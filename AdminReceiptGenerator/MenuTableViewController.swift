//
//  MenuTableViewController.swift
//  AdminReceiptGenerator
//
//  Created by Artem Misesin on 5/6/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

protocol NewItemDelegate {
    func sendDataBack(menuItem: MenuItem);
}


class MenuTableViewController: UITableViewController, NewItemDelegate, UISearchBarDelegate {

    var menu = Menu()
    
    var filteredMenu: [MenuItem] = []
    
    var menuItem = MenuItem()
    
    var newItems: [MenuItem] = []

    var delegate: OrderDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func sendDataBack(menuItem: MenuItem){
        self.menuItem = menuItem
        var _ = menu.push(self.menuItem)
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        if let delegate = self.delegate{
            delegate.sendDataBack(menuItems: newItems)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var doneBarItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menu.fetchPresets()
        self.tableView.backgroundColor = Colors.mainBackground
        self.view.backgroundColor = Colors.mainBackground
        searchBar.delegate = self
        self.navigationController?.navigationBar.tintColor = Colors.deleteColor;
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    override func viewWillAppear(_ animated: Bool) {
        
        filteredMenu = menu.storage
        tableView.reloadData()
//        if reloadNeeded{
//            tableView.beginUpdates()
//            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
//            tableView.endUpdates()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredMenu.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tempItem = MenuItem()
        tempItem.name = menu[indexPath.row].name
        tempItem.price = menu[indexPath.row].price
        newItems.insert(tempItem, at: 0)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        for (index, item) in newItems.enumerated() {
            if item.name == tableView.cellForRow(at: indexPath)?.textLabel?.text {
                newItems.remove(at: index)
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")!
        
        let price = filteredMenu[indexPath.row].price
        cell.textLabel?.text = filteredMenu[indexPath.row].name
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.string(from: price as NSNumber) {
            cell.detailTextLabel?.text = formattedAmount.replacingOccurrences(of: "UAH", with: "₴")
        }
        cell.backgroundColor = Colors.settingsMainTint
        cell.textLabel?.textColor = Colors.settingsText
        cell.detailTextLabel?.textColor = Colors.settingsText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            if self.searchBar.text == ""{
                self.menu.remove(at: indexPath.row)//self.menu.count - indexPath.row - 1)
                self.filteredMenu.remove(at: indexPath.row)
            } else {
                for (index, item) in self.menu.storage.enumerated(){
                    if item.name == tableView.cellForRow(at: indexPath)?.textLabel?.text {
                        self.menu.remove(at: index)
                        self.filteredMenu.remove(at: indexPath.row)
                        
                    }
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: {
        (action, indexPath) in
            self.performSegue(withIdentifier: "NewItem", sender: nil)
        }
        )
        
        edit.backgroundColor = UIColor(hexString: "#FFC61A", alpha: 1)
        
        return [delete]
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        filteredMenu = menu.storage
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredMenu = searchText.isEmpty ? menu.storage : menu.storage.filter { (item: MenuItem) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "NewItem"{
            if let destination = segue.destination as? NewItemViewController{
                destination.delegate = self
            }
        }
    }

}
