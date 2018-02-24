//
//  OneLineTableViewCell.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

struct OneLineCellModel: ContactDetailsCellModel {
  let title: String
}

class OneLineTableViewCell: UITableViewCell, ContactDetailsCellProtocol {
  static let xibName = "OneLineTableViewCell"
  
  @IBOutlet private weak var titleLabel: UILabel!
  
  func set(data: ContactDetailsCellModel) {
    guard let model = data as? OneLineCellModel else {
      return
    }
    
    titleLabel.text = model.title
  }
}
