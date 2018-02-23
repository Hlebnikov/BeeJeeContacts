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
  
  init(contactID: Int, firstName: String, phoneNumber: String) {
    self.contactID = contactID
    self.firstName = firstName
    self.phoneNumber = phoneNumber
  }
  
  init?(managedContactObject: ContactRecord) {
    guard let firstName = managedContactObject.firstName,
      let phoneNumber = managedContactObject.phoneNumber else {
        return nil
    }
    self.firstName = firstName
    self.phoneNumber = phoneNumber

    contactID = Int(managedContactObject.uniqueId)
    lastName = managedContactObject.lastName
    streetAddress1 = managedContactObject.streetAddress1
    streetAddress2 = managedContactObject.streetAddress2
    city = managedContactObject.city
    state = managedContactObject.state
    zipCode = managedContactObject.zipCode
  }
}
