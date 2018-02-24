//
//  ContactDetailsHeader.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 24.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

class ContactDetailsHeader: UIView {
  @IBOutlet private weak var firstNameLabel: UILabel!
  @IBOutlet private weak var lastNameLabel: UILabel!
  
  var firstName: String? {
    didSet {
      firstNameLabel.text = firstName
    }
  }
  
  var lastName: String? {
    didSet {
      lastNameLabel.text = lastName
    }
  }

  var view: UIView!
  let kNibName = "ContactDetailsHeader"
  private func xibSetup() {
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    addSubview(view)
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
