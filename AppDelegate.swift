//
//  AppDelegate.swift
//  iOSTest
//
//  Created by Aaron Fulmer on 1/17/20.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import UIKit
import Firebase
import FMDB 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 2.0)
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        dbMethod()
        return true
    }
    
    func dbMethod() {
        let database = FMDatabase(url: fileUrl)
        guard database.open() else {
            return
        }
        // Creates the Blood Pressure Table
        do {
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS BPTable (id INTEGER PRIMARY KEY AUTOINCREMENT, systolic TEXT, diastolic TEXT, date TEXT, time TEXT);", values: nil)
        }
        catch {
            print("\(error.localizedDescription)")
        }
        // Creates Blood Sugar Table
        do {
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS BloodSTable11 (id INTEGER PRIMARY KEY AUTOINCREMENT, bloodSugarLevel TEXT, fast TEXT, date TEXT, time TEXT);", values: nil)
        }
        catch {
            print("\(error.localizedDescription)")
        }
        
        // Creates the Cholesterol Table
        do {
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS CTable (id INTEGER PRIMARY KEY AUTOINCREMENT, TC TEXT, HDL TEXT, TRIG TEXT, LDL TEXT, date TEXT, time TEXT);", values: nil)
        }
        catch {
            print("\(error.localizedDescription)")
        }
        // Needs Editing
        // Creates the Vaccination Table
        do {
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS VaccTable (id INTEGER PRIMARY KEY AUTOINCREMENT, vaccination TEXT, status TEXT, date TEXT);", values: nil)
        }
        catch {
            print("\(error.localizedDescription)")
        }
        // Creates the Body Weight Table
        do {
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS BWTable (id INTEGER PRIMARY KEY AUTOINCREMENT, weight TEXT, date TEXT, time TEXT);", values: nil)
        }
        catch {
            print("\(error.localizedDescription)")
        }
        // Creates the Allergies Table
        do {
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS ATable (id INTEGER PRIMARY KEY AUTOINCREMENT, allergyName TEXT, allergyReaction TEXT);", values: nil)
        }
        catch {
            print("\(error.localizedDescription)")
        }
        // Creates the Medications Table
        do {
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS MedTable (id INTEGER PRIMARY KEY AUTOINCREMENT, medName TEXT, medDosage TEXT, dosageFrequency TEXT, medDelivery TEXT, takingStatus TEXT, rxNumber TEXT, pharmName TEXT, pharmNumber TEXT);", values: nil)
        }
        catch {
            print("\(error.localizedDescription)")
        }
        // Creates the User Profile Table
        do {
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS UPTable (id INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT, gender TEXT, date TEXT);", values: nil)
        }
        catch {
            print("\(error.localizedDescription)")
        }
        database.close()
    }
    

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

