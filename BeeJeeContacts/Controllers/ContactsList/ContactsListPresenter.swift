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
  func set(presenter: (ContactsListPresenterInput))
  func show(contacts: [Contact])
  func showAlert(title: String, message: String)
}

protocol ContactsListPresenterInput: class {
  func update()
  func delete(contact: Contact)
  func show(contact: Contact)
  func add(contact: Contact)
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
    interface?.show(contacts: contacts)
  }
  
  func delete(contact: Contact) {
    do {
      try contactsStorage.delete(byId: contact.contactID)
    } catch {
      interface?.showAlert(title: "Error".localized, message: "DeleteErrorMessage".localized)
    }
  }
  
  func show(contact: Contact) {
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
  
  func add(contact: Contact) {
    do {
      try contactsStorage.add(objects: [contact])
    } catch {
      interface?.showAlert(title: "Error".localized, message: "AddContactErrorMessage".localized)
    }
  }
}

extension ContactsListPresenter: ContactDetailsDelegate {
  func contactDetailsDidDelete(contact: Contact) {
    update()
  }
}
