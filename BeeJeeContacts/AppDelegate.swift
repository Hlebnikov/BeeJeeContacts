//
//  AppDelegate.swift
//  BeeJeeContacts
//
//  Created by Aleksandr X on 23.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let coreDataManager = CoreDataManager.shared
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    do {
      try ContactsStorage().cashContacsFromJsonIfNeeded(jsonName: "contacts")
    } catch ContactsStorageError.fileNotFound {
      print("The contacts file hasn't been found")
    } catch ContactsStorageError.invalidJson {
      print("The contact file is invalid")
    } catch {
      print("Unknown error while trying parse contacts")
    }
    
    let contactsViewController = ContactsListViewController()
    let contactsPresenter = ContactsListPresenter(viewController: contactsViewController,
                                                  contactsStorage: ContactsStorage())
    contactsViewController.setPresenter(presenter: contactsPresenter)
    
    window?.rootViewController = UINavigationController(rootViewController: contactsViewController)
    window?.makeKeyAndVisible()

    return true
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    coreDataManager.saveContext()
  }
}

