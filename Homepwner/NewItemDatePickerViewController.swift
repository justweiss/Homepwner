//
//  NewItemDatePickerViewController.swift
//  Homepwner
//
//  Created by Justin Weiss on 4/8/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class NewDatePickerViewController: UIViewController {
    var item: Item!
    
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBAction func backButton(_ sender: UIButton) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "NewItem") as! NewItemViewController
        print(myVC.datePickerDate)
        myVC.datePickerDate = datePicker.date
        print(datePicker.date)
        print(myVC.datePickerDate)
        navigationController?.popViewController(animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set the initial date to item's date created
        //datePicker.setDate(item.dateCreated, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "NewItem") as! NewItemViewController
        print(myVC.datePickerDate)
        myVC.datePickerDate = datePicker.date
        print(datePicker.date)
        print(myVC.datePickerDate)
        //navigationController?.pushViewController(myVC, animated: true)
        
        // "Save changes to item
        //NewItemViewController.self.datePickerDate = Date()
        //let date = datePicker.date
        //dateFromPicker.dateCreated = date
        
    }
}
