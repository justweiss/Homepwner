//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Justin Weiss on 3/18/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    //Creates itemStore to store cell data
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    //MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    //MARK: - Actions
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewItemViewController, let item = sourceViewController.item {
            
            print("Adding...")
            let newItem = itemStore.createItem(item: item)
            if let index = itemStore.allItems.index(of: newItem) {
                let indexPath = IndexPath(row: index, section: 0)
                
                //Inserts this new row into the table
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
            if let image = sourceViewController.imageView.image {
                imageStore.setImage(image, forKey: item.itemKey)
            }
            item.dateCreated = sourceViewController.datePickerDate
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            //Fugyre out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                //Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        case "AddItem"?:
            print("AddItem")
            
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    //Toggles editng mode
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
    
    //MARK: - TableView Methods
    // add a section for the "No more items!" cell
    // override UITableViewDataSource protocol
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 //CHANGE NUMBER
    } // end numberOfSections(in:)
    
    //Returns the number of items in the itemStore array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return itemStore.allItems.count
        
        if section == 0 {
            return itemStore.allItems.count
        } // end if
        else if section == 1 {    // section == 1 for the row that says "No more items!"
            return 1
        } // end else if
        else {
            print("More than 2 sections!!!")
           return 0
        } // ene else
    }
    
    //Creates the cells in the tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        if indexPath.section == 0 {
            // Set the text on the cell with the description of the
            // item that is at the nth index of items, where
            // n = row this cell will appear in on the tableview
            let item = itemStore.allItems[indexPath.row]
            
            //If value is greater than 50 make value red
            if item.valueInDollars >= 50 {
                cell.valueLabel.textColor = UIColor.red
            } else {
                //If less then 50 make value green
                cell.valueLabel.textColor = UIColor(red: 0, green: 0.6392, blue: 0.1569, alpha: 1.0)
            }
            
            // Configure the cell with the Item
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        } else {
            //If the cell is the first in the array, then creates the "No more items!" cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastItemCell", for: indexPath) as! LastItemCell
            //let item = itemStore.allItems[indexPath.row]
            cell.lastNameLabel.text = "No more items!"
            
            //Returns No more items cell
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
            //cell.backgroundColor = UIColor.clear
            return cell
    
        }
        
        return cell
    }
    
    //Function the detects and deletes cells
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            //Sets title and message for delete alert
            let title = "Remove \(item.name)?"
            let message = "Are you sure you want to remove this item?"
            
            //Creates an alert to prevent user from accidentaly deleteing an item
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            //If canel is clicked then goes back to the home screen
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            //If delete is clicked then it removes cell and its information from the store
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
                //Remove the item from the store
                self.itemStore.removeItem(item)
                
                //Remove the item's image from the image store
                
                //Also removed that row from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            //Present the alert controller
            present(ac, animated:  true, completion:  nil)
        }
    }
    
    //Function for moving the cells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    //Function that prevents the last item from being edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 0) ? true : false
    }
    
    //Prevents a cell from being moved below No more items
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        // desired location is still in section 0, let it happen
        if proposedDestinationIndexPath.section == 0 {
            return proposedDestinationIndexPath
        } else {
            // trying to move to section 1, put at end of section 0
            return IndexPath(row: itemStore.allItems.count - 1, section: 0)
        }
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
        //Sets the background picture
        tableView.backgroundView = UIImageView(image: UIImage(named: "basketball"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
}
