//
//  EditProfileEntry.swift
//  iOSTest
//
//  Created by FMU-SCRA on 1/13/21.
//  Copyright © 2021 Aaron Fulmer. All rights reserved.
//
import UIKit
import FMDB
import Toast_Swift

class EditProfileEntry: UIViewController{

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet var layer: CALayer!
    @IBOutlet var layer2: CALayer!
    
    @IBOutlet weak var txtDateBox: UITextField!
    var dateString: String!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var viewDate: UIView!
    
    @IBOutlet weak var radMale: UIButton!
    @IBOutlet weak var radFemale: UIButton!
    @IBOutlet weak var radOther: UIButton!
    @IBOutlet weak  var male: UILabel!
    @IBOutlet weak  var female: UILabel!
    @IBOutlet weak  var other: UILabel!
    
    let checkedImage = UIImage(named: "RadioChecked")
    let uncheckedImage = UIImage(named: "RadioUnchecked")
    var upDelegate: UPDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let checkedImage = UIImage(named: "RadioChecked")
        let uncheckedImage = UIImage(named: "RadioUnchecked")
        radMale.setImage(uncheckedImage, for: .normal)
        radMale.setImage(checkedImage, for: .selected)
        radFemale.setImage(uncheckedImage, for: .normal)
        radFemale.setImage(checkedImage, for: .selected)
         radOther.setImage(uncheckedImage, for: .normal)
        radOther.setImage(checkedImage, for: .selected)
    }
    
    @IBAction func enter(_ sender: UIButton) {
        if radMale.currentImage == checkedImage{
        deleteDB()
        insertDB()
        }
        else if radFemale.currentImage == checkedImage{
            deleteDB()
            insertDB1()
        }
        else if radOther.currentImage == checkedImage{
            deleteDB()
        insertDB2()
        }
    }
        
    @IBAction func Clear(_ sender: UIButton) {
        txtFirstName.text = nil
        txtLastName.text = nil
        txtDateBox.text = nil
    }
    @IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gohome(_ sender: Any) {
        performSegue(withIdentifier: "goHomeUPEntry", sender: self)
    }
    func deleteDB() {
        let FN = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let LN = txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let radM = male.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let date = txtDateBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let database  = FMDatabase(url: fileUrl)
            
            guard database.open() else {
                print("Unable to open database")
                return
            }
            let q = "DELETE FROM UPTable WHERE id = 1;"
             
            if (FN?.isEmpty)! || (LN?.isEmpty)! || (date?.isEmpty)! {
                self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
                return;
            }
            do {
                try database.executeUpdate(q, values: [FN!, LN!, radM!, date!])
                    print("Successful")
                    
                   self.view.makeToast("Profile Updated", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_userentered.png"))
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                     self.dismiss(animated: true,completion: nil)
                    }
                   
            }
                catch {
                    print("\(error.localizedDescription)")
                }
            database.close()
            upDelegate?.getUPData()
            self.navigationController?.popToRootViewController(animated: true)
        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                
        }
    
    func insertDB() {
        let FN = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let LN = txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let radM = male.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = txtDateBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        
         let qstate = "INSERT INTO UPTable(id, firstName, lastName, gender, date) values (1,?,?,?,?);"
        if (FN?.isEmpty)! || (LN?.isEmpty)! || (date?.isEmpty)! {
            self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
            return;
        }
        do {
            try database.executeUpdate(qstate, values: [FN!, LN!, radM!, date!])
                print("Successful")
                
                self.view.makeToast("Profile Updated", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_userentered.png"))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.dismiss(animated: true,completion: nil)
                }
               
        }
            catch {
                print("\(error.localizedDescription)")
            }
        database.close()
        upDelegate?.getUPData()
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    func insertDB1() {
        let FN = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let LN = txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let radF = female.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = txtDateBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
         let qstate = "INSERT INTO UPTable(id, firstName, lastName, gender, date) values (1,?,?,?,?);"
        if (FN?.isEmpty)! || (LN?.isEmpty)! || (date?.isEmpty)! {
            self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
            return;
        }
        do {
            try database.executeUpdate(qstate, values: [FN!, LN!, radF!, date!])
                print("Successful")
                
           self.view.makeToast("Profile Updated", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_userentered.png"))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
              self.dismiss(animated: true,completion: nil)
                }
               
        }
            catch {
                print("\(error.localizedDescription)")
            }
        database.close()
        upDelegate?.getUPData()
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    func insertDB2() {
        let FN = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let LN = txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let radO = other.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = txtDateBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
         let qstate = "INSERT INTO UPTable(id, firstName, lastName, gender, date) values (1,?,?,?,?);"
        if (FN?.isEmpty)! || (LN?.isEmpty)! || (date?.isEmpty)! {
            self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
            return;
        }
        do {
            try database.executeUpdate(qstate, values: [FN!, LN!, radO!, date!])
                print("Successful")
                
                self.view.makeToast("Profile Updated", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_userentered.png"))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.dismiss(animated: true,completion: nil)
                }
               
        }
            catch {
                print("\(error.localizedDescription)")
            }
        database.close()
        upDelegate?.getUPData()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func TextFirstNameActive(_ sender: Any) {
        if layer != nil{
        layer.frame = CGRect(origin: CGPoint(x: 0, y:txtFirstName.frame.height), size: CGSize(width: txtFirstName.frame.width, height:  2))
        txtFirstName.layer.addSublayer(layer)
        }
    }
    @IBAction func TextFirstNameInactive(_ sender: Any) {
        if layer != nil { layer.removeFromSuperlayer()
        }
    }
    @IBAction func TextLastNameActive(_ sender: Any) {
        if layer2 != nil {
        layer2.frame = CGRect(origin: CGPoint(x: 0, y:txtLastName.frame.height), size: CGSize(width: txtLastName.frame.width, height:  2))
        txtLastName.layer.addSublayer(layer2)
        }
    }
    @IBAction func TextLastNameInactive(_ sender: Any) {
        if layer2 != nil { layer2.removeFromSuperlayer()
        }
    }
    
    @IBAction func maleToggle(_ sender: Any) {
        radMale.setImage(checkedImage, for: UIControl.State.normal)
        radFemale.setImage(uncheckedImage, for: UIControl.State.normal)
        radOther.setImage(uncheckedImage, for: UIControl.State.normal)
    }
    
    @IBAction func femaleToggle(_ sender: Any) {
        radMale.setImage(uncheckedImage, for: UIControl.State.normal)
        radFemale.setImage(checkedImage, for: UIControl.State.normal)
        radOther.setImage(uncheckedImage, for: UIControl.State.normal)
    }
    
    @IBAction func otherToggle(_ sender: Any) {
        radMale.setImage(uncheckedImage, for: UIControl.State.normal)
        radFemale.setImage(uncheckedImage, for: UIControl.State.normal)
        radOther.setImage(checkedImage, for: UIControl.State.normal)
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
}
