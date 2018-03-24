//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Justin Weiss on 3/18/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    
    @IBAction func addNewItem(_ sender: UIButton) {
        //Create a new item and adds it to the store
        let newItem = itemStore.createItem()
        
        //Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index-1, section: 0)
            
            //Inserts this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        //If you are currently in editing mode...
        if isEditing {
            //Change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            
            //Turn off editing mode
            setEditing(false, animated: true)
        } else {
            //Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            
            //Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if itemStore.allItems.count > 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            let item = itemStore.allItems[indexPath.row+1]
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            if item.valueInDollars >= 50 {
                cell.valueLabel.textColor = UIColor.red
                //cell.valueLabel.text = "$\(item.valueInDollars)"
            } else {
                cell.valueLabel.textColor = UIColor(red: 0, green: 0.6392, blue: 0.1569, alpha: 1.0)
                //cell.valueLabel.text = "$\(item.valueInDollars)"
            }
            
            //cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastItemCell", for: indexPath) as! LastItemCell
            let item = itemStore.allItems[indexPath.row]
            cell.lastNameLabel.text = item.name
            
            //cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
            return cell
            
        }
        
        /*
        let item = itemStore.allItems[indexPath.row]
        print(item.name)
        //Get a new or recycled cell
        if item.name != "No More Items!" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            //Configure the cell with the item
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            if item.valueInDollars >= 50 {
                cell.valueLabel.textColor = UIColor.red
                //cell.valueLabel.text = "$\(item.valueInDollars)"
            } else {
                cell.valueLabel.textColor = UIColor(red: 0, green: 0.6392, blue: 0.1569, alpha: 1.0)
                //cell.valueLabel.text = "$\(item.valueInDollars)"
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastItemCell", for: indexPath) as! LastItemCell
            //cell.lastNameLabel.text = item.name
            return cell
        }*/
        
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        //let lastCell = tableView.dequeueReusableCell(withIdentifier: "LastItemCell", for: indexPath) as! LastItemCell
        
        //Set the text on the cell with the descriptuon of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item = itemStore.allItems[indexPath.row]
        
        print(itemStore.allItems.count)
        if itemStore.allItems.count > 1 {
            //Configure the cell with the item
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            if item.valueInDollars >= 50 {
                cell.valueLabel.textColor = UIColor.red
                //cell.valueLabel.text = "$\(item.valueInDollars)"
            } else {
                cell.valueLabel.textColor = UIColor(red: 0, green: 0.6392, blue: 0.1569, alpha: 1.0)
                //cell.valueLabel.text = "$\(item.valueInDollars)"
            }
            
        } else {
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = ""
            cell.valueLabel.text = ""
            
        }
        return cell */
 /*
        //Configure the cell with the item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        if item.valueInDollars >= 50 {
            cell.valueLabel.textColor = UIColor.red
            //cell.valueLabel.text = "$\(item.valueInDollars)"
        } else {
            cell.valueLabel.textColor = UIColor(red: 0, green: 0.6392, blue: 0.1569, alpha: 1.0)
            //cell.valueLabel.text = "$\(item.valueInDollars)"
        }
        
        return cell*/
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            //let title = "Delete \(item.name)?"
            let title = "Remove \(item.name)?"
            //let message = "Are you sure you want to delete this item?"
            let message = "Are you sure you want to remove this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
                //Remove the item from the store
                self.itemStore.removeItem(item)
                
                //Also removed that row from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            //Present the alert controller
            present(ac, animated:  true, completion:  nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        NSLog("func run")
        NSLog("\(indexPath.row)")
        NSLog("\(itemStore.allItems.count)")
        
        var edit = true
        
        if(indexPath.row == itemStore.allItems.count-1) {
            
            edit = false
        }
        
        return edit
        /*
        if itemStore.allItems.count > 1 {
            print("true")
            return true
        } else {
            print("False")
            return false
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        //tableView.rowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = UIImageView(image: UIImage(named: "basketball"))
    }
}
