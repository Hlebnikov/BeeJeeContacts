//
//  Contact.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 23.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import Foundation

struct Contact: Codable {
  let contactID: Int
  var firstName: String
  var phoneNumber: String
  
  var lastName: String?
  var streetAddress1: String?
  var streetAddress2: String?
  var city: String?
  var state: String?
  var zipCode: String?
}

