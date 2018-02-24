//
//  ContactDetailsPresenter.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import Foundation
import UIKit

protocol ContactDetailsPresenterInput: class {
  func saveContact(contact: Contact)
  func deleteContact()
  func update()
}

protocol ContactDetailsPresenterOutput: class {
  func showContact(contact: Contact)
  func showAlert(title: String, message: String)
  func setPresenter(presenter: ContactDetailsPresenterInput)
}

protocol ContactDetailsDelegate: class {
  func contactDetailsDidDelete(contact: Contact)
}

class ContactsDetailsPresenter: ContactDetailsPresenterInput {
  private let storage: ContactsStorage
  private weak var interface: (UIViewController & ContactDetailsPresenterOutput)!
  private var contact: Contact
  
  weak var delegate: ContactDetailsDelegate?
  
  init(viewController: UIViewController & ContactDetailsPresenterOutput, contact: Contact, storage: ContactsStorage) {
    interface = viewController
    self.contact = contact
    self.storage = storage
  }
  
  func update() {
    interface.showContact(contact: contact)
  }
  
  func saveContact(contact: Contact) {
    do {
      try storage.save(object: contact)
    } catch {
      interface.showAlert(title: "Error".localized, message: "SaveContactErrorMessage".localized)
    }
  }
  
  func deleteContact() {
    do {
      try storage.delete(byId: contact.contactID)
      delegate?.contactDetailsDidDelete(contact: contact)
      interface.navigationController?.popViewController(animated: true)
    } catch {
      interface.showAlert(title: "Error".localized, message: "DeleteContactErrorMessage".localized)
    }
  }
}
