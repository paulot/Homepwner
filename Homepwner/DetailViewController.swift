//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Paulo Tanaka on 2/5/16.
//  Copyright © 2016 Paulo Tanaka. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var serialNumberField: UITextField!
  @IBOutlet weak var valueField: UITextField!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet var imageView: UIImageView!

  var imageStore: ImageStore!

  var item: Item! {
    didSet {
      navigationItem.title = item.name
    }
  }

  let numberFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }()

  let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .NoStyle
    return formatter
  }()

  @IBAction func takePicture(sender: UIBarButtonItem) {
    let imagePicker = UIImagePickerController()

    // If the divice has a camera, take a picture; otherwise
    // just pick from photo library
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      imagePicker.sourceType = .Camera
    } else {
      imagePicker.sourceType = .PhotoLibrary
    }

    imagePicker.delegate = self

    // Place the image picker on the screen
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func backgroudTapped(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }

  @IBAction func setNewDate(sender: AnyObject) {
    view.endEditing(true)

    print("Not implemented")
  }

  @objc func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
    // Get picked image from info dictionary
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage

    imageStore.setImage(image, forKey: item.itemKey)

    // Put that image on the screen in the image view
    imageView.image = image

    // Take image picker off the screen -
    // you must call this dismiss method
    dismissViewControllerAnimated(true, completion: nil)
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    let key = item.itemKey
    let imageToDisplay = imageStore.imageForKey(key)
    imageView.image = imageToDisplay

    nameField.text = item.name
    serialNumberField.text = item.serialNumber
    valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
    dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)

    // Clear the first responder
    view.endEditing(true)

    // "Save" changes to item
    item.name = nameField.text ?? ""
    item.serialNumber = serialNumberField.text

    if let valueText = valueField.text, value = numberFormatter.numberFromString(valueText) {
      item.valueInDollars = value.integerValue
    } else {
      item.valueInDollars = 0
    }

  }
}