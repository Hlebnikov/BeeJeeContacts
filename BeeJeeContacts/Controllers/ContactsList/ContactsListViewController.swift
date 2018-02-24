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
    contactsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    contactsTable.dataSource = self

    title = "Контакты"
    presenter.update()
  }
  
  func setPresenter(presenter: (ContactsListPresenterInput)) {
    self.presenter = presenter
  }
  
  func showContacts(contacts: [Contact]) {
    sections = []
    let alphabet = "абвгдежзийклмнопрстуфхцчшщыюяabcdefghijklmnoprstuvxyz"
    for symbol in alphabet {
      let contacts = contacts.filter({ $0.firstName.lowercased().first == symbol })
      if !contacts.isEmpty {
        let section = ContactsSection(header: "\(symbol)".capitalized, contacts: contacts)
        sections.append(section)
      }
    }
    contactsTable.reloadData()
  }
  
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    present(alertController, animated: true, completion: nil)
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
