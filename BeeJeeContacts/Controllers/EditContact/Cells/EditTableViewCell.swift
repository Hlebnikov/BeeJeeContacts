//
//  EditTableViewCell.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {
  static let xibName = "EditTableViewCell"
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var editPlace: UITextField!
  
  var value: String? {
    get {
      return editPlace.text
    }
    set {
      editPlace.text = newValue
    }
  }
  
  var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
}

