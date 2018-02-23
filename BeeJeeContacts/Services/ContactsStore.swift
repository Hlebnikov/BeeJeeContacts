//
//  ContactsStore.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 23.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import Foundation
import CoreData

protocol Storage {
  associatedtype Object
  
  var allObjects: [Object] { get }
  func save(object: Object) throws
  func add(objects: [Object]) throws
  func load(byId id: Int) throws -> Object
  func delete(byId id: Int) throws
  func clear()
}

enum ContactsStorageError: Error {
  case fileNotFound
  case invalidJson
  case savingFailed
  case contactNotFound
}

class ContactsStorage: Storage {
  typealias Object = Contact

  private let coreDataManager = CoreDataManager.shared
  private let isJsonCashedKey = "isJsonCashed"
  private var isJsonCashed: Bool {
    get {
      return UserDefaults.standard.value(forKey: isJsonCashedKey) as? Bool ?? false
    }
    set {
      UserDefaults.standard.set(newValue, forKey: isJsonCashedKey)
    }
  }
  
  var allObjects: [Contact] {
    return contactsFromDataBase()
  }
  
  func clear() {
    let contacts = coreDataManager.getObjects(withType: CoreDataEntity.contact) as! [ContactRecord]
    let context = coreDataManager.persistentContainer.viewContext
    contacts.forEach({ context.delete($0) })
    coreDataManager.saveContext()
  }
  
  func reset() {
    clear()
    isJsonCashed = false
  }
  
  func save(object: Contact) throws {
    let maxId = maxContactId() + 1
    let newObject = try contactManagedObject(from: object)
    newObject.uniqueId = Int32(maxId)
    coreDataManager.saveContext()
  }
  
  func load(byId id: Int) throws -> Contact {
    let context = coreDataManager.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.contact.rawValue)
    request.predicate = NSPredicate(format: "uniqueId = %d", Int32(id))
    request.returnsObjectsAsFaults = false
    if let result = try context.fetch(request) as? [ContactRecord],
      let contactRecord = result.first,
      let contact = Contact(managedContactObject: contactRecord) {
        return contact
    }
    throw ContactsStorageError.contactNotFound
  }
  
  func delete(byId id: Int) throws {
    let context = coreDataManager.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.contact.rawValue)
    request.predicate = NSPredicate(format: "uniqueId = %d", Int32(id))
    request.returnsObjectsAsFaults = false
    if let result = try context.fetch(request) as? [ContactRecord],
      let contactRecord = result.first {
      context.delete(contactRecord)
      try context.save()
      return
    }
    throw ContactsStorageError.contactNotFound
  }
  
  func cashContacsFromJsonIfNeeded(jsonName: String) throws {
    if isJsonCashed {
      return
    }
    
    let contacts = try contactsFromJson(jsonName)
    try add(objects: contacts)
    isJsonCashed = true
  }
  
  /// Set new ids and then add them to data base
  func add(objects: [Contact]) throws {
    try objects.forEach { contact in
      let _ = try contactManagedObject(from: contact)
    }
    coreDataManager.saveContext()
  }
  
  /// Save contacts with current Id. If there is contact with this id then it be rewrite
  func save(contacts: [Contact]) throws {
    var maxId = maxContactId() + 1

    try contacts.forEach { contact in
      let newObject = try contactManagedObject(from: contact)
      newObject.uniqueId = Int32(maxId)
      maxId += 1
    }
    coreDataManager.saveContext()
  }
  
  private func contactManagedObject(from contact: Contact) throws -> ContactRecord {
    let context = coreDataManager.persistentContainer.viewContext
    if let contactEntityDescription = NSEntityDescription.entity(forEntityName: CoreDataEntity.contact.rawValue,
                                                                 in: context) {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.contact.rawValue)
      request.predicate = NSPredicate(format: "uniqueId = %d", Int32(contact.contactID))
      request.returnsObjectsAsFaults = false
      let result = try context.fetch(request) as? [ContactRecord]
      let managedContact = result?.first ?? ContactRecord(entity: contactEntityDescription, insertInto: context)
      if result?.first == nil {
        managedContact.uniqueId = Int32(contact.contactID)
      }
      managedContact.firstName = contact.firstName
      managedContact.lastName = contact.lastName
      managedContact.phoneNumber = contact.phoneNumber
      managedContact.state = contact.state
      managedContact.streetAddress1 = contact.streetAddress1
      managedContact.streetAddress2 = contact.streetAddress2
      managedContact.zipCode = contact.zipCode
      return managedContact
    }
    throw ContactsStorageError.savingFailed
  }
  
  private func maxContactId() -> Int {
    let contacts = coreDataManager.getObjects(withType: CoreDataEntity.contact) as! [ContactRecord]
    return Int(contacts.max(by: {$0.uniqueId > $1.uniqueId})?.uniqueId ?? 0)
  }
  
  private func contactsFromJson(_ jsonName: String) throws -> [Contact] {
    guard let path = Bundle.main.path(forResource: jsonName, ofType: "json") else {
      throw ContactsStorageError.fileNotFound
    }
    
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
      let contacts = try JSONDecoder().decode([Contact].self, from: data)
      return contacts
    } catch {
      throw ContactsStorageError.invalidJson
    }
  }
  
  private func contactsFromDataBase() -> [Contact] {
    guard let objects = coreDataManager.getObjects(withType: .contact),
      let contacts = objects as? [ContactRecord] else {
      return []
    }
    
    return contacts.flatMap({ Contact(managedContactObject: $0) })
  }
}
