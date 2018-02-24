//
//  BeeJeeContactsTests.swift
//  BeeJeeContactsTests
//
//  Created by Aleksandr X on 23.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import XCTest
@testable import BeeJeeContacts

class BeeJeeContactsTests: XCTestCase {
  private let storage = ContactsStorage()
  
  override func setUp() {
    ContactsStorage().reset()
  }

  func testClearing() {
    addContact()
    XCTAssert(storage.allObjects.count == 1)
    storage.clear()
    XCTAssert(storage.allObjects.isEmpty)
  }
  
  func testCashing() {
    do {
      try storage.cashContacsFromJsonIfNeeded(jsonName: "testContacts")
      if let contact = storage.allObjects.first {
        XCTAssert(contact.contactID == 123, "\(contact.contactID)")
        XCTAssert(contact.firstName == "Тест", contact.firstName)
        XCTAssert(contact.lastName == "Тестов", contact.lastName ?? "")
      } else {
        XCTFail()
      }
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
  
  func testSaving() {
    let contact = Contact(contactID: 321, firstName: "Иван", phoneNumber: "Иванов")
    do {
      try storage.add(objects: [contact])
    } catch {
      XCTFail()
    }
    if let savedContact = storage.allObjects.first {
      XCTAssert(savedContact.contactID == contact.contactID, "\(contact.contactID)")
      XCTAssert(savedContact.firstName == contact.firstName, contact.firstName)
      XCTAssert(savedContact.lastName == contact.lastName, contact.lastName ?? "")
    } else {
      XCTFail()
    }
  }
  
  func testDeleting() {
    addContact()
    do {
      try storage.delete(byId: 321)
    } catch {
      XCTFail(error.localizedDescription)
    }
    XCTAssert(storage.allObjects.isEmpty)
  }
  
  private func addContact() {
    let contact = Contact(contactID: 321, firstName: "Иван", phoneNumber: "Иванов")
    do {
      try storage.add(objects: [contact])
    } catch {
      XCTFail()
    }
  }
  
  override func tearDown() {
    storage.reset()
  }
}

