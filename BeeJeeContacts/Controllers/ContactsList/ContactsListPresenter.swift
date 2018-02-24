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
  func deleteContact(withIndex index: Int)
  func showContact(withIndex index: Int)
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
  
  func deleteContact(withIndex index: Int) {
    let id = contacts[index].contactID
    do {
      try contactsStorage.delete(byId: id)
    } catch {
      interface?.showAlert(title: "Ошибка", message: "Не удалось удалить контакт")
    }
  }
  
  func showContact(withIndex index: Int) {
    //показать информацию
  }
  
  func addContact() {
    //показать диалог добавления
  }
}
