//
//  ContactDetailFooter.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

class ContactDetailsFooter: UIView {
  @IBOutlet private weak var deleteButton: UIButton!
  @IBOutlet private weak var editButton: UIButton!
  
  var onDelete: ()->Void = {}
  var onEdit: ()->Void = {}
  
  @IBAction private func tapButton() {
    onDelete()
  }
  
  @IBAction private func tapEdit() {
    onEdit()
  }

  var view: UIView!
  let kNibName = "ContactDetailsFooter"
  private func xibSetup() {
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    addSubview(view)
    
    deleteButton.setTitle("Delete".localized, for: .normal)
    editButton.setTitle("Edit".localized, for: .normal)
  }
  
  private func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: kNibName, bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    xibSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    xibSetup()
  }

}
