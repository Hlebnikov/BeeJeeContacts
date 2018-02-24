//
//  ContactDetailsViewController.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController, ContactDetailsPresenterOutput {
  @IBOutlet private weak var infoTable: UITableView!
  
  private var presenter: ContactDetailsPresenterInput!
  private var units = [(cellType: ContactDetailsCellProtocol.Type, model: ContactDetailsCellModel)]()
  private var header = ContactDetailsHeader(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
  private let footer = ContactDetailsFooter(frame: CGRect(x: 0, y: 0, width: 300, height: 120))
  
  override func viewDidLoad() {
    infoTable.register(UINib(nibName: OneLineTableViewCell.xibName, bundle: nil), forCellReuseIdentifier: OneLineTableViewCell.xibName)
    infoTable.register(UINib(nibName: SubtitledTableViewCell.xibName, bundle: nil), forCellReuseIdentifier: SubtitledTableViewCell.xibName)
    infoTable.dataSource = self
    infoTable.delegate = self
    
    infoTable.tableFooterView = footer
    presenter.update()
  }

  func showContact(contact: Contact) {
    units = units(from: contact)
    header.firstName = contact.firstName
    header.lastName = contact.lastName
    
    footer.onDelete = { [unowned self] in
      self.presenter.deleteContact()
    }
    
    footer.onEdit = { [unowned self] in
      let editVC = EditContactViewController(contact: contact)
      editVC.delegate = self
      self.present(UINavigationController(rootViewController: editVC), animated: true, completion: nil)
    }
    
    infoTable.reloadData()
  }
  
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
  
  func setPresenter(presenter: ContactDetailsPresenterInput) {
    self.presenter = presenter
  }
  
  private func units(from contact: Contact) -> [(cellType: ContactDetailsCellProtocol.Type, model: ContactDetailsCellModel)] {
    var units = [(cellType: ContactDetailsCellProtocol.Type, model: ContactDetailsCellModel)]()
    units.append((OneLineTableViewCell.self, OneLineCellModel(title: contact.phoneNumber)))
    units.append((cellType: SubtitledTableViewCell.self, model: SubtitledCellModel(title: "City".localized, subtitle: contact.city ?? "")))
    units.append((cellType: SubtitledTableViewCell.self, model: SubtitledCellModel(title: "State".localized, subtitle: contact.state ?? "")))
    units.append((cellType: SubtitledTableViewCell.self, model: SubtitledCellModel(title: "Address 1".localized, subtitle: contact.streetAddress1 ?? "")))
    units.append((cellType: SubtitledTableViewCell.self, model: SubtitledCellModel(title: "Address 2".localized, subtitle: contact.streetAddress2 ?? "")))
    units.append((cellType: SubtitledTableViewCell.self, model: SubtitledCellModel(title: "Zip code".localized, subtitle: contact.zipCode ?? "")))

    return units
  }
}

extension ContactDetailsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return units.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let unit = units[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: unit.cellType.xibName, for: indexPath) as? (UITableViewCell & ContactDetailsCellProtocol)
    cell?.set(data: unit.model)
    return cell ?? UITableViewCell()
  }
}

extension ContactDetailsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 120
  }
}

extension ContactDetailsViewController: EditContactViewControllerDelegate {
  func contactEditorDidEdit(contact: Contact) {
    presenter.save(contact: contact)
  }
  
  func contactEditorDidCancel() {
    
  }
}
