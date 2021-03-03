//
//  SearchService.swift
//  iOSTest
//
//  Created by FMU-SCRA on 2/8/21.
//  Copyright © 2021 Aaron Fulmer. All rights reserved.
//

import Foundation
import UIKit


public class SearchService {
    var name: String?
    var address: String?
    var phone: String?
    var schedule: String?
    var distance: Double?
    var services: String?
    var url: String?
    var latitude: Double?
    var longitude: Double?
    
    init(_ locationName: String, _ searchAddress: String, _ searchDistance: Double, _ searchPhone: String, _ searchSchedule: String, _ searchServices: String, _ searchURL: String, _ searchLatitude: Double, _ searchLongitude: Double) {
        self.name = locationName
        self.address = searchAddress
        self.distance = searchDistance
        self.phone = searchPhone
        self.schedule = searchSchedule
        self.services = searchServices
        self.url = searchURL
        self.latitude = searchLatitude
        self.longitude = searchLongitude
        
    }
///maps/search/?api=1&query=47.5951518,-122.3316393&query_place_id=ChIJKxjxuaNqkFQR3CK6O1HNNqY
    @IBAction func openURL(_ sender: Any) {
        guard let myURL = URL(string: "http://\(String(describing: url))") else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(myURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(myURL)
        }
    }
   /* @IBAction func openMap(_ sender: Any) {
        guard let url = URL(string: "http://maps.google.com/maps?daddr =\(latitude),\(longitude)", "Getting Directions") else {
                 return //be safe
               }
               if #available(iOS 10.0, *) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                   UIApplication.shared.openURL(url)
               }
    } */
    public func getAddress() -> String {
        return address!
    }
    
    public func getName() -> String {
        return name!
    }
}
