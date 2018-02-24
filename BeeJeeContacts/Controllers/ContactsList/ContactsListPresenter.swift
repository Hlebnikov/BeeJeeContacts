//
//  ContactsListPresenter.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import Foundation
import UIKit

protocol ContactsListPresenterOutput: class {
  func setPresenter(presenter: (ContactsListPresenterInput))
  func showContacts(contacts: [Contact])
  func showAlert(title: String, message: String)
}

protocol ContactsListPresenterInput: class {
  func update()
  func deleteContact(_ contact: Contact)
  func showContact(_ contact: Contact)
  func addContact()
}

class ContactsListPresenter: NSObject, ContactsListPresenterInput {
  private let contactsStorage: ContactsStorage
  private weak var interface: (UIViewController & ContactsListPresenterOutput)?
  
  var contacts = [Contact]()
  
  init(viewController: (UIViewController & ContactsListPresenterOutput), contactsStorage: ContactsStorage) {
    self.contactsStorage = contactsStorage
    self.interface = viewController
  }
  
  func update() {
    contacts = contactsStorage.allObjects
    interface?.showContacts(contacts: contacts)
  }
  
  func deleteContact(_ contact: Contact) {
    do {
      try contactsStorage.delete(byId: contact.contactID)
    } catch {
      interface?.showAlert(title: "Error".localized, message: "DeleteErrorMessage".localized)
    }
  }
  
  func showContact(_ contact: Contact) {
    let viewController = ContactDetailsViewController()
    let presenter = ContactsDetailsPresenter(viewController: viewController,
                                             contact: contact,
                                             storage: contactsStorage)
    presenter.delegate = self
    viewController.setPresenter(presenter: presenter)
    
    DispatchQueue.main.async {
      self.interface?.show(viewController, sender: nil)
    }
    
  }
  
  func addContact() {
    
  }
}

extension ContactsListPresenter: ContactDetailsDelegate {
  func contactDetailsDidDelete(contact: Contact) {
    update()
  }
}
