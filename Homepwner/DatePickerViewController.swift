//
//  DatePickerViewController.swift
//  Homepwner
//
//  Created by Justin Weiss on 3/28/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
   var item: Item!
    
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set the initial date to item's date created
        datePicker.setDate(item.dateCreated, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // "Save changes to item
        //NewItemViewController.self.datePickerDate = Date()
        let date = datePicker.date
        item.dateCreated = date
        
    }
}
