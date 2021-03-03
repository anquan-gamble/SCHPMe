//
//  DBManager.swift
//  iOSTest
//
//  Created by FMU on 3/18/20.
//  Copyright © 2020 Garriss Moseley. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
import Toast_Swift
import FMDB

let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("SCHPMe.sqlite")

class BPData: NSObject {
    var id: String?
    var systolic: String?
    var diastolic: String?
    var date: String?
    var time: String?
}
class BSData: NSObject {
    var id: String?
    var bloodSugarLevel: String?
    var fast: String?
    var date: String?
    var time: String?
}
class CHData: NSObject {
    var id: String?
    var TC: String?
    var HDL: String?
    var TRIG: String?
    var LDL: String?
    var date: String?
    var time: String?
}

class VData: NSObject {
    var id: String?
    var vaccination: String?
    var status: String?
    var date: String?
    
  //  var entry = VaccinationEntry()
    
}
class BWData: NSObject {
    var id: String?
    var weight: String?
    var date: String?
    var time: String?
}
class AData: NSObject {
    var id: String?
    var allergyName: String?
    var allergyReaction: String?
}
class MData: NSObject {
    var id: String?
    var medName: String?
    var medDosage: String?
    var dosageFrequency: String?
    var medDelivery: String?
    var takingStatus: String?
    var rxNumber: String?
    var pharmName: String?
    var pharmNumber: String?
}
class UPData: NSObject {
    var id: String?
    var firstName: String?
    var lastName: String?
    var gender: String?
    var date: String?
}


