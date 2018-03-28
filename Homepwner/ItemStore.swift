//
//  ItemStore.swift
//  Homepwner
//
//  Created by Justin Weiss on 3/18/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class ItemStore {
    //Create the item store
    var allItems = [Item]()
    
    //Creates the No More Items item as the first value
    /*
    init() {
        let newItem = Item(name: "No More Items!", serialNumber: nil, valueInDollars: 0)
        allItems.append(newItem)
    }*/
    
    //function the is called when you add a new item to the tableview and creates a new item in the store
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    //Removes item from the store
    func removeItem(_ item: Item) {
        if let index = allItems.index(of: item){
            allItems.remove(at: index)
        }
    }
    
    //Moves item in the store
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        //Get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        //Remove items from array
        allItems.remove(at: fromIndex)
        
        //Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
}
