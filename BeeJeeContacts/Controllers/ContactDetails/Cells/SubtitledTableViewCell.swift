//
//  SubtitledTableViewCell.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

struct SubtitledCellModel: ContactDetailsCellModel {
  let title: String
  let subtitle: String
}

class SubtitledTableViewCell: UITableViewCell, ContactDetailsCellProtocol {  
  static let xibName = "SubtitledTableViewCell"
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var subtitleLabel: UILabel!
  
  func set(data: ContactDetailsCellModel) {
    guard let model = data as? SubtitledCellModel else {
      return
    }
    
    titleLabel.text = model.title
    subtitleLabel.text = model.subtitle
  }
}
