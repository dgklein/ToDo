//
//  AppDelegate.swift
//  ToDo
//
//  Created by Dara Klein on 7/22/18.
//  Copyright © 2018 Dara Klein. All rights reserved.
//
import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
//print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // Create Realm dBase
        do {
            _ = try Realm()
        } catch {
            print("Error initializing Realm \(error)")
        }
        return true
    }

}

