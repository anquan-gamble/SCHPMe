//
//  Location.swift
//  iOSTest
//
//  Created by FMU-SCRA on 2/15/21.
//  Copyright © 2021 Aaron Fulmer. All rights reserved.
//

import Foundation

class Location {
    
    private(set) var name: String!
    private(set) var address: String!
    private(set) var phone: String!
    private(set) var schedule: String!
    private(set) var distance: Double!
    private(set) var services: String!
    private(set) var url: String!
    private(set) var latitude: Double!
    private(set) var longitude: Double!
    
    init(locationName: String, searchAddress: String, searchDistance: Double,  searchPhone: String, searchSchedule: String, searchServices: String,  searchURL: String, searchLatitude: Double, searchLongitude: Double) {
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
}
