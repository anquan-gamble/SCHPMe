//
//  bwNewEntry.swift
//  iOSTest
//
//  Created by FMU-SCRA on 10/14/20.
//  Copyright © 2020 Anquan Gamble. All rights reserved.
//

import UIKit
import SQLite3
import Toast_Swift
import FMDB

class BodyWeightEntry: UIViewController {
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet var layer: CALayer!
    @IBOutlet var layer2: CALayer!
    @IBOutlet weak var txtBodyWeight: UITextField!
    @IBOutlet weak var txtDateBox: UITextField!
    @IBOutlet weak var txtTimeBox: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var time: UIDatePicker!
    var dateString: String!
    var timeString: String!
    var bwDelegate: BWDataDelegate?
    
    @IBAction func enter(_ sender: UIButton) {
        insertDB()
    }
    
    @IBAction func Clear(_ sender: UIButton) {
        txtBodyWeight.text = nil
        txtTimeBox.text = nil
        txtDateBox.text = nil
    }
    
    func insertDB() {
        let weight = txtBodyWeight.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = txtDateBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let time = txtTimeBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            let database  = FMDatabase(url: fileUrl)
            
            guard database.open() else {
                print("Unable to open database")
                return
            }
            let qstate = "INSERT INTO BWTable (weight, date, time) values (?,?,?);"
            if (weight?.isEmpty)! || (date?.isEmpty)! || (time?.isEmpty)! {
                self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
                return;
            }
                do {
                    try database.executeUpdate(qstate, values: [weight!, date!, time!])
                    print("idk")
                    
                    self.view.makeToast("Body Weight Entered", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_checkmark.png"))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                      self.dismiss(animated: true,completion: nil)
                    }
                   
            }
                catch {
                    print("\(error.localizedDescription)")
                }
            
            database.close()
            bwDelegate?.getBWData()
            self.navigationController?.popViewController(animated: true)
        }
    @IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gohome(_ sender: Any) {
        performSegue(withIdentifier: "goHomeBwEntry", sender: self)
    }
    @IBAction func bodyWeightActive(_ sender: Any) {
        layer.frame = CGRect(origin: CGPoint(x: 0, y:txtBodyWeight.frame.height), size: CGSize(width: txtBodyWeight.frame.width, height: 2))
        txtBodyWeight.layer.addSublayer(layer)
    }
    
    @IBAction func bodyWeightInactive(_ sender: Any) {
        layer.removeFromSuperlayer()
    }
    
    @IBAction func dateActive(_ sender: Any) {
        viewDate.isHidden = false
        viewDate.isExclusiveTouch = true
        txtDateBox.endEditing(true)
    }
    @IBAction func datePicked(_ sender: Any) {
        viewDate.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        dateString = dateFormatter.string(from: date.date)
        txtDateBox.text = dateString
        txtDateBox.isEnabled = false
        txtDateBox.isEnabled = true
    }
    @IBAction func dateCancel(_ sender: Any) {
        viewDate.isHidden = true
        txtDateBox.isEnabled = false
        txtDateBox.isEnabled = true
    }
    
    @IBAction func timeActivate(_ sender: Any) {
        viewTime.isHidden = false
        viewTime.isExclusiveTouch = true
        txtTimeBox.endEditing(true)
    }
    
    @IBAction func timePicked(_ sender: Any) {
        viewTime.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeString = dateFormatter.string(from: time.date)
        txtTimeBox.text = timeString
        txtTimeBox.isEnabled = false
        txtTimeBox.isEnabled = true
    }
    @IBAction func timeCancel(_ sender: Any) {
        viewTime.isHidden = true
        txtTimeBox.isEnabled = false
        txtTimeBox.isEnabled = true
    }
    func toolBar() {
        let toolBar = UIToolbar()
               toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        txtBodyWeight.inputAccessoryView = toolBar
    }
    override func viewDidLoad() {
       super.viewDidLoad()
    // Do any additional setup after loading the view.
       self.toolBar()
     
     var bottomLine = CALayer()
       bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtBodyWeight.frame.height), size: CGSize(width: txtBodyWeight.frame.width, height: 1))
       bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
       txtBodyWeight.borderStyle = UITextField.BorderStyle.none
       txtBodyWeight.layer.addSublayer(bottomLine)
        
        
       
       bottomLine = CALayer()
       bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtDateBox.frame.height), size: CGSize(width: txtBodyWeight.frame.width, height: 1))
       bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
       txtDateBox.layer.addSublayer(bottomLine)
       bottomLine = CALayer()
       bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtTimeBox.frame.height), size: CGSize(width: txtBodyWeight.frame.width, height: 1))
       bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
       txtTimeBox.layer.addSublayer(bottomLine)
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "MMM dd, YYYY"
       dateString = dateFormatter.string(from: date.date)
       txtDateBox.text = dateString
       dateFormatter.dateFormat = "HH:mm"
       timeString = dateFormatter.string(from: time.date)
       txtTimeBox.text = timeString
       layer = CALayer()
       layer.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
       layer2 = CALayer()
       layer2.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
     }
     @objc func doneClicked() {
       view.endEditing(true)
     }
}
