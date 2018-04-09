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
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var locationField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    
    let locations = ["Bedroom", "Bathroom", "Kitchen", "Dining Room", "Living Room", "Garage"]
    var selectedLocation: String?
    
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
            
            //Adds cross hair to camera
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
        
        //Put that image on the screen in the image view
        imageView.image = image
        
        //Take image picker off the screen
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Remove Picture
    @IBAction func removePicture(_ sender: UIBarButtonItem) {
        
        //Removes the image from the screen
        imageView.image = nil
        
    }
    
    //MARK: - Changed Date ViewController
    // override UIViewController method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Checks to see if savebutton was click
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            print("Cancel")
            return
        }
        
        //If save was click then prepares date to be sent to Items view controller
        let name = nameField.text
        let serialNumber = serialNumberField.text
        let location = locationField.text
        var Value = 0
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText) {
            Value = value.intValue
        }
        item = Item(name: name!, serialNumber: serialNumber, valueInDollars: Value, location: location!)
        print(datePickerDate)
        
    }
    
    //Looks to see if name field and value field are empty
    func textFieldDidEndEditing(_ textField: UITextField) {
        //If empty save remains blocked out
        if nameField.text == "" || valueField.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    //Checks if date picker is changed
    @objc func datePickerValueChanged(sender: UIDatePicker) {

        datePickerDate = sender.date
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes save button invisable
        saveButton.isEnabled = false
        
        //Creates location picker
        createLocationPicker()
        createToolbar()
        
        //Creates Date picker
        let datePicker = UIDatePicker()
        
        //Sets the date to the create date
        datePicker.datePickerMode = UIDatePickerMode.date
        
        //Looks to change in date picker date
        datePicker.addTarget(self, action: #selector(NewItemViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        dateTextField.inputView = datePicker
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Updates date when user returns to screen
        dateTextField.text = dateFormatter.string(from: datePickerDate)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Clear first responder
        view.endEditing(true)
    }
}

//Creates location picker
extension NewItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Sets and adds all information for location picker
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
        
        label.text = locations[row]
        
        return label
    }
}

