//
//  ContactDetailsCellProtocol.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import Foundation

protocol ContactDetailsCellModel {
  
}

protocol ContactDetailsCellProtocol {
  static var xibName: String { get }
  func set(data: ContactDetailsCellModel)
}
