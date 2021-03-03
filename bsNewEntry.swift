//
//  ViewController.swift
//  iOSTest
//
//  Created by Aaron Fulmer on 3/7/20.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import UIKit
import SQLite3
import Toast_Swift
import FMDB

class BloodSugarEntry: UIViewController {
 
    
    @IBOutlet weak var BSLTextBox: UITextField!
    @IBOutlet var layer: CALayer!
    //@IBOutlet var layer2: CALayer!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var txtDateBox: UITextField!
    @IBOutlet weak var txtTimeBox: UITextField!
    @IBOutlet weak var radFasting: UIButton!
    @IBOutlet weak var radNonfasting: UIButton!
    
    
    @IBOutlet weak  var fasting: UILabel!
    @IBOutlet weak  var nonfasting: UILabel!
    
    let checkedImage = UIImage(named: "RadioChecked")
    let uncheckedImage = UIImage(named: "RadioUnchecked")
    var dateString: String!
    var timeString: String!
    var bsDelegate: BSDataDelegate?
    
   // let toggle = [fasting,nonfasting]
    
    
    
    @IBAction func enter(_ sender: UIButton) {
        //radNonfasting.isSelected = !radNonfasting.isSelected
        if radNonfasting.currentImage == checkedImage{
        insertDB()
        }
        else if radFasting.currentImage == checkedImage{
            insertDB1()
        }
    }
    func insertDB() {
        
        let bsl = BSLTextBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let radNF = nonfasting.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = txtDateBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let time = txtTimeBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //let toggle = [radF,radNF]
        
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        let qstate = "INSERT INTO BloodSTable11 (bloodSugarLevel, fast, date, time) values (?,?,?,?);"
        if (bsl?.isEmpty)! || (date?.isEmpty)! || (time?.isEmpty)! {
            self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
            return;
        }

        do {
            try database.executeUpdate(qstate, values: [bsl!, radNF!, date!, time!])
                print("idk")
                
                self.view.makeToast("Blood Sugar Entered", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_checkmark.png"))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.dismiss(animated: true,completion: nil)
                }
               
        }
            catch {
                print("\(error.localizedDescription)")
            }
        database.close()
        bsDelegate?.getBSData()
        self.navigationController?.popViewController(animated: true)
        
    }
    func insertDB1() {
        
        let bsl = BSLTextBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let radF = fasting.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = txtDateBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let time = txtTimeBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //let toggle = [radF,radNF]
        
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        let qstate = "INSERT INTO BloodSTable11 (bloodSugarLevel, fast, date, time) values (?,?,?,?);"
        if (bsl?.isEmpty)! || (date?.isEmpty)! || (time?.isEmpty)! {
            self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
            return;
        }

        do {
            try database.executeUpdate(qstate, values: [bsl!, radF!, date!, time!])
                print("idk")
                
                self.view.makeToast("Blood Sugar Entered", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_checkmark.png"))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.dismiss(animated: true,completion: nil)
                }
               
        }
            catch {
                print("\(error.localizedDescription)")
            }
        database.close()
        bsDelegate?.getBSData()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func Clear(_ sender: UIButton) {
        BSLTextBox.text = nil
        txtTimeBox.text = nil
        txtDateBox.text = nil
    }
    @IBAction func unwind(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gohome(_ sender: Any) {
        
        performSegue(withIdentifier: "goHomeBsEntry", sender: self)
    }
    
    
    
    @IBAction func BSLTextActive(_ sender: Any) {
        layer.frame = CGRect(origin: CGPoint(x: 0, y:BSLTextBox.frame.height), size: CGSize(width: BSLTextBox.frame.width, height:  2))
        BSLTextBox.layer.addSublayer(layer)
    }
    
    
    @IBAction func BSLTextInactive(_ sender: Any) {
        layer.removeFromSuperlayer()
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
    @IBAction func fastToggle(_ sender: Any) {
        radFasting.setImage(checkedImage, for: UIControl.State.normal)
        radNonfasting.setImage(uncheckedImage, for: UIControl.State.normal)
    }
    @IBAction func nonfastToggle(_ sender: Any) {
        radFasting.setImage(uncheckedImage, for: UIControl.State.normal)
        radNonfasting.setImage(checkedImage, for: UIControl.State.normal)
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
        BSLTextBox.inputAccessoryView = toolBar
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let checkedImage = UIImage(named: "RadioChecked")
        let uncheckedImage = UIImage(named: "RadioUnchecked")
        radFasting.setImage(uncheckedImage, for: .normal)
        radFasting.setImage(checkedImage, for: .selected)
        radNonfasting.setImage(uncheckedImage, for: .normal)
        radNonfasting.setImage(checkedImage, for: .selected)
        self.toolBar()
        
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:BSLTextBox.frame.height), size: CGSize(width: BSLTextBox.frame.width, height:  1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        BSLTextBox.borderStyle = UITextField.BorderStyle.none
        BSLTextBox.layer.addSublayer(bottomLine)
        
    
        
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtDateBox.frame.height), size: CGSize(width: BSLTextBox.frame.width, height:  1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtDateBox.layer.addSublayer(bottomLine)
        
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtTimeBox.frame.height), size: CGSize(width: BSLTextBox.frame.width, height:  1))
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
    }
    @objc func doneClicked() {
        view.endEditing(true)
    }
}

