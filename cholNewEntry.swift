//
//  ViewController.swift
//  iOSTest
//
//  Created by Aaron Fulmer on 3/9/2020.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import UIKit
import SQLite3
import Toast_Swift
import FMDB

class CholesterolEntry: UIViewController {


    @IBOutlet weak var txtTC: UITextField!
    @IBOutlet weak var txtHDL: UITextField!
    @IBOutlet weak var txtTRIG: UITextField!
    @IBOutlet weak var txtLDL: UITextField!
    @IBOutlet      var layer:           CALayer!
    @IBOutlet      var layer2:          CALayer!
    @IBOutlet weak var viewDate:        UIView!
    @IBOutlet weak var viewTime:        UIView!
    @IBOutlet weak var date:            UIDatePicker!
    @IBOutlet weak var time:            UIDatePicker!
    @IBOutlet weak var txtDateBox:      UITextField!
    @IBOutlet weak var txtTimeBox:      UITextField!
                   var dateString:      String!
                   var timeString:      String!
    var chDelegate: CHDataDelegate?
    

    
    @IBAction func enter(_ sender: UIButton) {
        insertDB()
    }
    
    func insertDB() {
        
        let tc = txtTC.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let hdl = txtHDL.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trig = txtTRIG.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let ldl = txtLDL.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = txtDateBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let time = txtTimeBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        let qstate = "INSERT INTO CTable (TC, HDL, TRIG, LDL, date, time) values (?,?,?,?,?,?);"
        if (tc?.isEmpty)! || (hdl?.isEmpty)! || (trig?.isEmpty)! || (ldl?.isEmpty)! || (date?.isEmpty)! || (time?.isEmpty)! {
            self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
            return;
        }
            do {
                try database.executeUpdate(qstate, values: [tc!, hdl!, trig!, ldl!, date!, time!])
                print("idk")
                
                self.view.makeToast("Cholesterol Entered", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_checkmark.png"))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.dismiss(animated: true,completion: nil)
                }
               
        }
            catch {
                print("\(error.localizedDescription)")
            }
        
        database.close()
      //  chDelegate?.getCHData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Clear(_ sender: UIButton) {
        txtTC.text = nil
        txtHDL.text = nil
        txtTRIG.text = nil
        txtLDL.text = nil
        txtTimeBox.text = nil
        txtDateBox.text = nil
    }
    
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()

        
    }
    
    @IBAction func unwind(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gohome(_ sender: Any) {
        
        performSegue(withIdentifier: "goHomeChEntry", sender: self)
    }
    
    
    
    
    @IBAction func tcActive(_ sender: Any) {
        layer.frame = CGRect(origin: CGPoint(x: 0, y:txtTC.frame.height), size: CGSize(width: txtTC.frame.width, height:  2))
        txtTC.layer.addSublayer(layer)
    }
    
    
    @IBAction func tcInactive(_ sender: Any) {
        layer.removeFromSuperlayer()
    }
    
    
    
    @IBAction func hdlActive(_ sender: Any) {
        layer2.frame = CGRect(origin: CGPoint(x: 0, y:txtHDL.frame.height), size: CGSize(width: txtHDL.frame.width, height:  2))
        txtHDL.layer.addSublayer(layer2)
    }
    
    
    @IBAction func hdlInactive(_ sender: Any) {
        layer2.removeFromSuperlayer()
    }
    
    @IBAction func trigActive(_ sender: Any) {
        layer2.frame = CGRect(origin: CGPoint(x: 0, y:txtTRIG.frame.height), size: CGSize(width: txtTRIG.frame.width, height:  2))
        txtTRIG.layer.addSublayer(layer2)
    }
    
    
    @IBAction func trigInactive(_ sender: Any) {
        layer2.removeFromSuperlayer()
    }
    
    @IBAction func ldlActive(_ sender: Any) {
        layer2.frame = CGRect(origin: CGPoint(x: 0, y:txtLDL.frame.height), size: CGSize(width: txtLDL.frame.width, height:  2))
        txtLDL.layer.addSublayer(layer2)
    }
    
    
    @IBAction func ldlInactive(_ sender: Any) {
        layer2.removeFromSuperlayer()
    }
    
    
    @IBAction func dateActivate(_ sender: Any) {
        viewDate.isHidden = false
        viewDate.isExclusiveTouch = true
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
        txtTC.inputAccessoryView = toolBar
        txtHDL.inputAccessoryView = toolBar
        txtTRIG.inputAccessoryView = toolBar
        txtLDL.inputAccessoryView = toolBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.toolBar()
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtTC.frame.height), size: CGSize(width: txtTC.frame.width, height:  1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtTC.borderStyle = UITextField.BorderStyle.none
        txtTC.layer.addSublayer(bottomLine)
        
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtHDL.frame.height), size: CGSize(width: txtHDL.frame.width, height:  1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtHDL.borderStyle = UITextField.BorderStyle.none
        txtHDL.layer.addSublayer(bottomLine)
        
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtDateBox.frame.height), size: CGSize(width: txtHDL.frame.width, height:  1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtDateBox.layer.addSublayer(bottomLine)
        
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtTimeBox.frame.height), size: CGSize(width: txtHDL.frame.width, height:  1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtTimeBox.layer.addSublayer(bottomLine)
        
        
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtTRIG.frame.height), size: CGSize(width: txtHDL.frame.width, height:  1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtTRIG.borderStyle = UITextField.BorderStyle.none
        txtTRIG.layer.addSublayer(bottomLine)
        
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtLDL.frame.height), size: CGSize(width: txtHDL.frame.width, height:  1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtLDL.layer.addSublayer(bottomLine)
        
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

