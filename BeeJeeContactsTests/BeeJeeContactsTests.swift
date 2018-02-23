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
  
  func testDecodeJson() {
    XCTAssert(!ContactsStorage().allObjects.isEmpty)
  }
}

