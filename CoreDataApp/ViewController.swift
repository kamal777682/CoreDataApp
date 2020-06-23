//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Kamalpreet Kaur on 2020-06-23.
//  Copyright © 2020 Kamalpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myProductTextField: UITextField!
    @IBOutlet weak var mypriceTextField: UITextField!
    
    var dataManager : NSManagedObjectContext!
    var listArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        myLabel.text?.removeAll()
        
        fetchData()
        // Do any additional setup after loading the view.
    }
    func fetchData() {
    let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
    do {
    let result = try dataManager.fetch(fetchRequest)
        listArray = result as! [NSManagedObject]
    for item in listArray {
    let product = item.value(forKey: "name") as! String
        let cost = item.value(forKey: "price") as! String
        myLabel.text! += product + " " + cost + ", "
    }
    } catch {
    print ("Error retrieving data") }
    }
    @IBAction func addDataButton(_ sender: UIButton) {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Item", into: dataManager)
        newEntity.setValue(myProductTextField.text!, forKey: "name")
        newEntity.setValue(mypriceTextField.text!, forKey: "price")
        do {
        try
            self.dataManager.save()
            listArray.append(newEntity)
        } catch {
        print ("Error saving data")
        }
        myLabel.text?.removeAll()
        myProductTextField.text?.removeAll()
        mypriceTextField.text?.removeAll()
        fetchData()
    }
    
    @IBAction func deleteDataButton(_ sender: UIButton) {
        let deleteItem = myProductTextField.text!
        for item in listArray {
        if item.value(forKey: "name") as! String == deleteItem { dataManager.delete(item)
        }
        }
        do {
        try self.dataManager.save() } catch {
        print ("Error deleting data") }
        myLabel.text?.removeAll()
        myProductTextField.text?.removeAll()
        fetchData()
    }
}

