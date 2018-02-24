//
//  EditContactViewController.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

protocol EditContactViewControllerDelegate: class {
  func contactEditorDidEdit(contact: Contact)
  func contactEditorDidCancel()
}


class EditContactViewController: UIViewController {

  private enum CellType: String {
    case name
    case surname
    case phone
    case state
    case address1
    case address2
    case zipCode
  }
  
  @IBOutlet private weak var tableView: UITableView!
  
  private var contact: Contact!
  
  weak var delegate: EditContactViewControllerDelegate?
  
  convenience init(contact: Contact) {
    self.init()
    self.contact = contact
  }
  
  private var contactDictionary = [CellType: String]()
  private var cells: [CellType] = [.name, .surname, .phone, .state, .address1, .address2, .zipCode]
  override func viewDidLoad() {
    tableView.register(UINib(nibName: EditTableViewCell.xibName, bundle: nil), forCellReuseIdentifier: EditTableViewCell.xibName)
    contactDictionary = dictionary(from: contact)
    tableView.dataSource = self
    
    let okItem = UIBarButtonItem(title: "OK".localized, style: .done, target: self, action: #selector(okAction))
    let cancelItem = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(cancelAction))
    navigationItem.rightBarButtonItem = okItem
    navigationItem.leftBarButtonItem = cancelItem
  }
  
  @objc
  private func okAction() {
    fillContact()
    delegate?.contactEditorDidEdit(contact: contact)
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
  @objc
  private func cancelAction() {
    delegate?.contactEditorDidCancel()
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
  private func dictionary(from contact: Contact) -> [CellType: String] {
    let dict: [CellType: String] = [
      .name : contact.firstName,
      .surname: contact.lastName ?? "",
      .phone: contact.phoneNumber,
      .state: contact.state ?? "",
      .address1: contact.streetAddress1 ?? "",
      .address2: contact.streetAddress2 ?? "",
      .zipCode: contact.zipCode ?? ""
    ]
    
    return dict
  }
  
  private func fillContact() {
    for (index, cellType) in cells.enumerated() {
      if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EditTableViewCell {
        let value = cell.value ?? ""
        switch cellType {
        case .name:
          contact.firstName = value
        case .surname:
          contact.lastName = value
        case .phone:
          contact.phoneNumber = value
        case .address1:
          contact.streetAddress1 = value
        case .address2:
          contact.streetAddress2 = value
        case .zipCode:
          contact.zipCode = value
        case .state:
          contact.state = value
        }
      }
    }
  }
}

extension EditContactViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cells.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: EditTableViewCell.xibName, for: indexPath) as? EditTableViewCell
    cell?.title = cells[indexPath.row].rawValue.localized
    cell?.value = contactDictionary[cells[indexPath.row]]
    return cell ?? UITableViewCell()
  }
}

