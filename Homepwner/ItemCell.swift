//
//  ItemCell.swift
//  Homepwner
//
//  Created by Justin Weiss on 3/20/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    //Creates the labels for the cell prototype
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    //Updates font if the user changes the font size
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
    }
}

class LastItemCell: UITableViewCell {
    
    //Creates the label for the No more items cell prototype
    @IBOutlet var lastNameLabel: UILabel!
    
    //Updates font if the user changes the font size
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lastNameLabel.adjustsFontForContentSizeCategory = true

    }
}
