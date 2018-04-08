//
//  NewItemViewController.swift
//  Homepwner
//
//  Created by Justin Weiss on 4/8/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //Creates itemStore to store cell data
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    var item: Item!
    var datePickerDate = Date()
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Resign First Responder
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK: - Picture Actions
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        //If the device has a camera, take a picture, otherwise just pick photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            
            let crossHair = UIButton(type: .contactAdd)
            crossHair.tintColor = UIColor.white
            crossHair.translatesAutoresizingMaskIntoConstraints = false
            imagePicker.cameraOverlayView?.addSubview(crossHair)
            imagePicker.cameraOverlayView?.isUserInteractionEnabled = false
            
            crossHair.centerXAnchor.constraint(equalTo: (imagePicker.cameraOverlayView?.centerXAnchor)!).isActive = true
            crossHair.centerYAnchor.constraint(equalTo: (imagePicker.cameraOverlayView?.centerYAnchor)!).isActive = true
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        //Place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        //Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //Store the image in the ImageStore for the item's key
        //imageStore.setImage(image, forKey: item.itemKey)
        
        //Put that image on the screen in the image view
        imageView.image = image
        
        //Take image picker off the screen
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Remove Picture
    @IBAction func removePicture(_ sender: UIBarButtonItem) {
        
        //Deletes the image from the imageStore
        //imageStore.deleteImage(forKey: item.itemKey)
        
        //Removes the image from the screen
        imageView.image = nil
        
    }
    
    //MARK: - Changed Date ViewController
    // override UIViewController method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the triggered segue is the "ShowItem" segue
        // note that it all seems to work without this identifier check
        if segue.identifier == "NewItemDate" {
            print("NewItemDate")
            
            // take advantage of DetailViewController's item
            // which is was obtained from ItemViewController
            // in ItemViewController's implementation of prepare(for:_:)
            //let datePickerViewController = segue.destination as! DatePickerViewController
            //datePickerViewController.datePicker = dateLabel
            
        }
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            print("Cancel")
            return
        }
        let name = nameField.text
        let serialNumber = serialNumberField.text
        var Value = 0
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText) {
            Value = value.intValue
        }
        item = Item(name: name!, serialNumber: serialNumber, valueInDollars: Value)
        print(datePickerDate)
        //let imageStore = imageView.image
        
        //DatePickerViewController.datePicker
        
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = dateFormatter.string(from: datePickerDate)
        
        //saveButton.isEnabled = false
        
        //nameField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateLabel.text = dateFormatter.string(from: datePickerDate)
        
        //nameField.text = item.name
        //serialNumberField.text = item.serialNumber
        //valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        //dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        //Get the item key
        //let key = item.itemKey
        
        //If there is an associated image with the item display it on the image view
        //let imageToDisplay = imageStore.image(forKey: key)
        //imageView.image = imageToDisplay
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Clear first responder
        view.endEditing(true)
        
        // "Save" changes to item”
        //item.name = nameField.text ?? ""
        //item.serialNumber = serialNumberField.text
        
        //if let valueText = valueField.text,
        //    let value = numberFormatter.number(from: valueText) {
        //    item.valueInDollars = value.intValue
        //} else {
        //    item.valueInDollars = 0
        //}
    }
}
