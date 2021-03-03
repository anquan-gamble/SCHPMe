//
//  VacCellView.swift
//  iOSTest
//
//  Created by FMU-SCRA on 1/3/21.
//  Copyright © 2021 Aaron Fulmer. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()
        }
    
    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    func configureV(dict: VData) {
        typeLabel.text = dict.vaccination
//        lblstatus.text = dict.status
        lbldate.text = dict.date
    }
}

