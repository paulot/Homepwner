//
//  ItemCell.swift
//  Homepwner
//
//  Created by Paulo Tanaka on 2/4/16.
//  Copyright © 2016 Paulo Tanaka. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var serialNumberLabel: UILabel!
  @IBOutlet var valueLabel: UILabel!
  
  func updateLabels() {
    let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    nameLabel.font = bodyFont

    let caption1Font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    serialNumberLabel.font = caption1Font

    if let value = Int(String(valueLabel.text!.characters.dropFirst())) where value >= 50 {
      valueLabel.textColor = UIColor.greenColor()
    } else {
      valueLabel.textColor = UIColor.blackColor()
    }
  }
}