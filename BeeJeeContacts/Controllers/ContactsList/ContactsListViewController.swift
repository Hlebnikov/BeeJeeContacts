//
//  ContactsListViewController.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

struct ContactsSection {
  var header: String
  var contacts: [Contact]
}

class ContactsListViewController: UIViewController, ContactsListPresenterOutput {
  private var presenter: ContactsListPresenterInput!

  @IBOutlet private weak var contactsTable: UITableView!
  
  private var sections = [ContactsSection]()
  
  init() {
    super.init(nibName: "ContactsListViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Contacts".localized

    contactsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    contactsTable.dataSource = self
    contactsTable.delegate = self

    let addButton = UIBarButtonItem(title: "Add".localized, style: .plain, target: self, action: #selector(addAction))
    navigationItem.rightBarButtonItem = addButton
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter.update()
  }
  
  @objc
  private func addAction() {
    let newContact = Contact(contactID: 0, firstName: "", phoneNumber: "")
    let editVC = EditContactViewController(contact: newContact)
    editVC.delegate = self
    present(UINavigationController(rootViewController: editVC), animated: true, completion: nil)
  }
  
  func set(presenter: (ContactsListPresenterInput)) {
    self.presenter = presenter
  }
  
  func show(contacts: [Contact]) {
    sections = splitByAlphabet(contacts: contacts)
    contactsTable.reloadData()
  }
  
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    present(alertController, animated: true, completion: nil)
  }
  
  private func splitByAlphabet(contacts: [Contact]) -> [ContactsSection] {
    var sections: [ContactsSection] = []
    let alphabet = "абвгдежзийклмнопрстуфхцчшщыюяabcdefghijklmnoprstuvxyz"
    for symbol in alphabet {
      let contacts = contacts.filter({ $0.firstName.lowercased().first == symbol })
      if !contacts.isEmpty {
        let section = ContactsSection(header: "\(symbol)".capitalized, contacts: contacts)
        sections.append(section)
      }
    }
    let other = contacts.filter({ contact in
      if let firstLetter = contact.firstName.lowercased().first {
        return !alphabet.contains(firstLetter)
      }
      return true
    })
    let section = ContactsSection(header: "Other".localized, contacts: other)
    sections.append(section)
    return sections
  }
}

extension ContactsListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].contacts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .value2, reuseIdentifier: "cell")
    let contact = sections[indexPath.section].contacts[indexPath.row]
    cell.textLabel?.text = "\(contact.firstName) \(contact.lastName ?? "")"
    cell.detailTextLabel?.text = "\(contact.phoneNumber)"
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].header
  }
}

extension ContactsListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedContact = sections[indexPath.section].contacts[indexPath.row]
    presenter.show(contact: selectedContact)
  }
}

extension ContactsListViewController: EditContactViewControllerDelegate {
  func contactEditorDidEdit(contact: Contact) {
    presenter.add(contact: contact)
  }
  
  func contactEditorDidCancel() {
    
  }
}
