//
//  DetailsTextField.swift
//  Homepwner
//
//  Created by Paulo Tanaka on 2/5/16.
//  Copyright © 2016 Paulo Tanaka. All rights reserved.
//

import UIKit


class DetailsTextField: UITextField {
  override func becomeFirstResponder() -> Bool {
    super.becomeFirstResponder()
    self.borderStyle = .Bezel
    return true
  }

  override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    self.borderStyle = .RoundedRect
    return true
  }
}