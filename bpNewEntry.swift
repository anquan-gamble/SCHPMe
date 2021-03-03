//
//  ViewController.swift
//  iOSTest
//
//  Created by Aaron Fulmer on 1/17/20.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import UIKit
import Toast_Swift
import FMDB

class BloodPressureEntry: UIViewController{
    @IBOutlet weak var txtSystolic: UITextField!
    @IBOutlet weak var txtDiastolic: UITextField!
    @IBOutlet var layer: CALayer!
    @IBOutlet var layer2: CALayer!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var txtDateBox: UITextField!
    @IBOutlet weak var txtTimeBox: UITextField!
    var dateString: String!
    var timeString: String!
    var bpDelegate: BPDataDelegate?
    

    @IBAction func enter(_ sender: UIButton) {
        insertDB()
    }
    
    func insertDB() {
        
        let systolic = txtSystolic.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let diastolic = txtDiastolic.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = txtDateBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let time = txtTimeBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        let qstate = "INSERT INTO BPTable (systolic, diastolic, date, time) values (?,?,?,?);"
        if (systolic?.isEmpty)! || (diastolic?.isEmpty)! || (date?.isEmpty)! || (time?.isEmpty)! {
        
            return;
        }
            do {
                try database.executeUpdate(qstate, values: [systolic!, diastolic!, date!, time!])
                print("idk")
                
                self.view.makeToast("Blood Pressure Entered", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_checkmark.png"))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.dismiss(animated: true,completion: nil)
                }
               
        }
            catch {
                print("\(error.localizedDescription)")
            }
        
        database.close()
        bpDelegate?.getBPData()
        self.navigationController?.popViewController(animated: true)
    }


    @IBAction func Clear(_ sender: UIButton) {
        txtSystolic.text = nil
        txtDiastolic.text = nil
        txtTimeBox.text = nil
        txtDateBox.text = nil
    }
    @IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func gohome(_ sender: Any) {
        performSegue(withIdentifier: "goHomeBpEntry", sender: self)
    }
    @IBAction func txtSystolicActive(_ sender: Any) {
        layer.frame = CGRect(origin: CGPoint(x: 0, y:txtSystolic.frame.height), size: CGSize(width: txtSystolic.frame.width, height: 2))
        txtSystolic.layer.addSublayer(layer)
    }
    @IBAction func txtSystolicInactive(_ sender: Any) {
        layer.removeFromSuperlayer()
    }
    @IBAction func txtDiastolicActive(_ sender: Any) {
        layer2.frame = CGRect(origin: CGPoint(x: 0, y:txtDiastolic.frame.height), size: CGSize(width: txtDiastolic.frame.width, height: 2))
        txtDiastolic.layer.addSublayer(layer2)
    }
    @IBAction func txtDiastolicInactive(_ sender: Any) {
        layer2.removeFromSuperlayer()
    }
    @IBAction func dateActivate(_ sender: Any) {
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
        txtDiastolic.inputAccessoryView = toolBar
        txtSystolic.inputAccessoryView = toolBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     // Do any additional setup after loading the view.
        self.toolBar()
        
        
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtSystolic.frame.height), size: CGSize(width: txtSystolic.frame.width, height: 1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtSystolic.borderStyle = UITextField.BorderStyle.none
        txtSystolic.layer.addSublayer(bottomLine)
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtDiastolic.frame.height), size: CGSize(width: txtDiastolic.frame.width, height: 1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtDiastolic.borderStyle = UITextField.BorderStyle.none
        txtDiastolic.layer.addSublayer(bottomLine)
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtDateBox.frame.height), size: CGSize(width: txtDiastolic.frame.width, height: 1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtDateBox.layer.addSublayer(bottomLine)
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtTimeBox.frame.height), size: CGSize(width: txtDiastolic.frame.width, height: 1))
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
