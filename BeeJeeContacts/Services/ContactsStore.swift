//
//  ContactsStore.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 23.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import Foundation

protocol Storage {
  associatedtype Object
  
  var allObjects: [Object] { get }
  func save(object: Object)
  func loadObject(byId id: Int) -> Object?
}

enum ContactsStorageError: Error {
  case fileNotFound
  case invalidJson
}

class ContactsStorage: Storage {
  typealias Object = Contact

  private let isJsonCashedKey = "isJsonCashedKey"
  private var isJsonCashed: Bool {
    get {
      return UserDefaults.standard.value(forKey: isJsonCashedKey) as? Bool ?? false
    }
    set {
      UserDefaults.standard.set(newValue, forKey: isJsonCashedKey)
    }
  }
  
  var allObjects: [Contact] {
    return (try? contactsFromJson("contacts")) ?? []
  }
  
  func save(object: Contact) {
    
  }
  
  func loadObject(byId id: Int) -> Contact? {
    return nil
  }
  
  private func contactsFromJson(_ jsonName: String) throws -> [Contact] {
    guard let path = Bundle.main.path(forResource: "contacts", ofType: "json") else {
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
}
