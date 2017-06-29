//
//  MenuModel.swift
//  AdminReceiptGenerator
//
//  Created by Artem Misesin on 5/7/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit
import CoreData

public struct Menu {
    
    var storage: [MenuItem] = []
    
    mutating func push(_ item: MenuItem) -> Bool{
        if !existing(value: item.name){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: "MenuDBItem", into: context)
            
            newEntry.setValue(item.name, forKey: "name")
            newEntry.setValue(item.price, forKey: "price")
            
            let tempItem = MenuItem()
            tempItem.name = item.name
            tempItem.price = item.price
            
            do {
                try context.save()
            } catch {
                print("Error while inserting into database")
            }
            storage.insert(tempItem, at: 0)
            return true
        }
        return false
    }
    
    subscript(index: Int) -> MenuItem {
        return storage[index]
    }
    
    var count: Int{
        get {
            return storage.count
        }
    }
    
    mutating func swap(_ toIndex: Int, with fromIndex: Int){
        let itemToMove = storage[fromIndex]
        remove(at: fromIndex)
        storage.insert(itemToMove, at: toIndex)
    }
    
    mutating func remove(at index: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MenuDBItem")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                context.delete(results[results.count - index - 1] as! NSManagedObject)
                storage.remove(at: index)
            }
        } catch {
            print("Error while deleting")
        }
        do {
            try context.save()
        } catch {
            print("Error while saving the context")
        }
    }
    
    func existing(value: String) -> Bool{
        for item in storage {
            if item.name == value {
                return true
            }
        }
        return false
    }
    
    mutating func fetchPresets(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MenuDBItem")
        request.returnsObjectsAsFaults = false
        do {
            
            let results = try context.fetch(request) as! [NSManagedObject]
            if results.count > 0 {
                storage = []
                for result in results {
                    let tempItem = MenuItem()
                    tempItem.name = (result.value(forKey: "name") as! String).capitalized
                    tempItem.price = result.value(forKey: "price") as! Double
                    storage.insert(tempItem, at: 0)
                }
            }
        } catch {
            print("Error while fetching in getEntries")
        }
    }
}
