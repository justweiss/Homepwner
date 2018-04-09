//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Justin Weiss on 3/26/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Initializers
    var imageStore: ImageStore!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var locationField: UITextField!
    
    let locations = ["Bedroom", "Bathroom", "Kitchen", "Dining Room", "Living Room", "Garage"]
    var selectedLocation: String?
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
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
    
    //MARK: - Location Selector
    func createLocationPicker() {
        
        let locationPicker = UIPickerView()
        locationPicker.delegate = self
        
        locationField.inputView = locationPicker
        
        //Customizations
        locationPicker.backgroundColor = .black
    }
    
    
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DetailViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        locationField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        imageStore.setImage(image, forKey: item.itemKey)
        
        //Put that image on the screen in the image view
        imageView.image = image
        
        //Take image picker off the screen
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Remove Picture
    @IBAction func removePicture(_ sender: UIBarButtonItem) {
        
        //Deletes the image from the imageStore
        imageStore.deleteImage(forKey: item.itemKey)
        
        //Removes the image from the screen
        imageView.image = nil
        
    }
    
    //MARK: - Changed Date ViewController
    // override UIViewController method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the triggered segue is the "ShowItem" segue
        // note that it all seems to work without this identifier check
        if segue.identifier == "ChangeDate" {
            
            // take advantage of DetailViewController's item
            // which is was obtained from ItemViewController
            // in ItemViewController's implementation of prepare(for:_:)
            let datePickerViewController = segue.destination as! DatePickerViewController
            datePickerViewController.item = item
            //item.dateCreated = datePickerViewController.datePicker.date
            
        }
    }
    
    //MARK: - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        //Get the item key
        let key = item.itemKey
        
        //If there is an associated image with the item display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Clear first responder
        view.endEditing(true)
        
        // "Save" changes to item”
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createLocationPicker()
        createToolbar()
    }
}

// MARK: - Custon TextField
class UICustomTextField: UITextField {
    override func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        
        borderStyle = .line
        return becomeFirstResponder
    }
    override func resignFirstResponder() -> Bool {
        let resignFirstResponder = super.resignFirstResponder()
        
        borderStyle = .roundedRect
        return resignFirstResponder
    }
}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedLocation = locations[row]
        locationField.text = selectedLocation
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .white
        label.textAlignment = .center
        //label.font = UIFont(name: "Menlo-Regular", size: 17)
        
        label.text = locations[row]
        
        return label
    }
}
