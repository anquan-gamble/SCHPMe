//
//  DBManager.swift
//  iOSTest
//
//  Created by FMU on 3/18/20.
//  Copyright © 2020 Anquan Gamble. All rights reserved.
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
class BWData: NSObject {
    var id: String?
    var weight: String?
    var date: String?
    var time: String?
}
