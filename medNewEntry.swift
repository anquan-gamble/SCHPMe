//
//  medNewEntry.swift
//  iOSTest
//
//  Created by FMU-SCRA on 12/17/20.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import Foundation
import SQLite3
import UIKit
import Toast_Swift
import FMDB

class MedicationsEntry: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var scrollView:      UIScrollView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDosage: UITextField!
    @IBOutlet weak var txtFrequency: UITextField!
    
    @IBOutlet weak var viewTypes: UIView!
    @IBOutlet weak var delivery: UIPickerView!
    @IBOutlet weak var deliveryButton: UIButton!
    @IBOutlet weak var deliveryTypeLabel: UILabel!
    let types = ["Oral (Tablet)", "Oral (Liquid)", "Sublingual", "Rectal", "Topical (Cream)", "Topical (Eye Drop)", "Topical (Ear Drop)", "Intramuscular", "Subcutaneous"]
    var pickerView = UIPickerView()
    
    @IBOutlet weak var txtRX: UITextField!
    @IBOutlet weak var txtpharmName: UITextField!
    @IBOutlet weak var txtpharmNumber: UITextField!
    var mDelegate: MDataDelegate?
    @IBOutlet var layer: CALayer!
    @IBOutlet var layer2: CALayer!
    
    @IBOutlet weak var radYes: UIButton!
    
    @IBOutlet weak var radNo: UIButton!
    @IBOutlet weak var Yes: UILabel!
    
    @IBOutlet weak var No: UILabel!
    let checkedImage = UIImage(named: "RadioChecked")
    let uncheckedImage = UIImage(named: "RadioUnchecked")
    
    
    override func viewDidLoad() {
           super.viewDidLoad()

        let checkedImage = UIImage(named: "RadioChecked")
        let uncheckedImage = UIImage(named: "RadioUnchecked")
        radYes.setImage(uncheckedImage, for: .normal)
        radYes.setImage(checkedImage, for: .selected)
        radNo.setImage(uncheckedImage, for: .normal)
        radNo.setImage(checkedImage, for: .selected)
        
           delivery.isHidden = true
           delivery.delegate = self
           delivery.dataSource = self
           
       }
    
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
     //  scrollView.contentSize = CGSize(width: 330, height: 710)
        
    }
    
    @IBAction func enter(_ sender: UIButton) {
        if radYes.currentImage == checkedImage{
            insertDB()
        }
        else if radNo.currentImage == checkedImage{
            insertDB1()
        }
    }
    
    @IBAction func Clear(_ sender: UIButton) {
        txtName.text = nil
        txtDosage.text = nil
        txtFrequency.text = nil
        txtRX.text = nil
        txtpharmName.text = nil
        txtpharmNumber.text = nil
    }
    
    @IBAction func unwind(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gohome(_ sender: Any) {
        
        performSegue(withIdentifier: "goHomeMedEntry", sender: self)
    }
    func insertDB() {
        let name = txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let dosage = txtDosage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let frequency = txtFrequency.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let radY = Yes.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let RX = txtRX.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let deliveryLabel = deliveryTypeLabel.text
        let pharmName = txtpharmName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pharmNumb = txtpharmNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        let qstate = "INSERT INTO MedTable (medName, medDosage, dosageFrequency, medDelivery, takingStatus, rxNumber, pharmName, pharmNumber) values (?,?,?,?,?,?,?,?);"
        
        if (name?.isEmpty)! || (dosage?.isEmpty)! || (frequency?.isEmpty)! || (RX?.isEmpty)! || (pharmName?.isEmpty)! || (pharmNumb?.isEmpty)! {
            self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
            return;
        }
        do {
                try database.executeUpdate(qstate, values: [name!, dosage!, frequency!, deliveryLabel!, radY!, RX!, pharmName!, pharmNumb!])
                    print("Successful")
                    
                    self.view.makeToast("Medication Entered", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_checkmark.png"))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                      self.dismiss(animated: true,completion: nil)
                    }
                   
            }
                catch {
                    print("\(error.localizedDescription)")
                }
            database.close()
            mDelegate?.getMData()
            self.navigationController?.popViewController(animated: true)
    }
    func insertDB1() {
        let name = txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let dosage = txtDosage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let frequency = txtFrequency.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let radN = Yes.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let RX = txtRX.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let deliveryLabel = deliveryTypeLabel.text
        let pharmName = txtpharmName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pharmNumb = txtpharmNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        let qstate = "INSERT INTO MTable (medName, medDosage, dosageFrequency, medDelivery, takingStatus, rxNumber, pharmName, pharmNumber) values (?,?,?,?,?,?,?,?);"
        
        if (name?.isEmpty)! || (dosage?.isEmpty)! || (frequency?.isEmpty)! || (RX?.isEmpty)! || (pharmName?.isEmpty)! || (pharmNumb?.isEmpty)! {
            self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
            return;
        }
        do {
                try database.executeUpdate(qstate, values: [name!, dosage!, frequency!, deliveryLabel!, radN!, RX!, pharmName!, pharmNumb!])
                    print("Successful")
                    
                    self.view.makeToast("Medication Entered", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_checkmark.png"))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                      self.dismiss(animated: true,completion: nil)
                    }
                   
            }
                catch {
                    print("\(error.localizedDescription)")
                }
            database.close()
            mDelegate?.getMData()
            self.navigationController?.popViewController(animated: true)
    }

    @IBAction func txtNameActive(_ sender: Any) {
        layer2.frame = CGRect(origin: CGPoint(x: 1, y:txtName.frame.height), size: CGSize(width: txtName.frame.width, height: 1))
        txtName.layer.addSublayer(layer2)
    }
    @IBAction func txtNameInactive(_ sender: Any) {
        layer.removeFromSuperlayer()
    }
    @IBAction func txtDosageActive(_ sender: Any) {
        layer2.frame = CGRect(origin: CGPoint(x: 1, y:txtDosage.frame.height), size: CGSize(width: txtDosage.frame.width, height: 1))
        txtName.layer.addSublayer(layer2)
    }
    @IBAction func txtDosageInactive(_ sender: Any) {
        layer.removeFromSuperlayer()
    }
    @IBAction func txtFrequencyActive(_ sender: Any) {
        layer2.frame = CGRect(origin: CGPoint(x: 1, y:txtFrequency.frame.height), size: CGSize(width: txtFrequency.frame.width, height: 1))
        txtName.layer.addSublayer(layer2)
    }
    @IBAction func txtFrequencyInactive(_ sender: Any) {
        layer.removeFromSuperlayer()
    }
    
    
    @IBAction func yesToggle(_ sender: Any) {
        radYes.setImage(checkedImage, for: UIControl.State.normal)
        radNo.setImage(uncheckedImage, for: UIControl.State.normal)
    }
    @IBAction func noToggle(_ sender: Any) {
        radNo.setImage(checkedImage, for: UIControl.State.normal)
        radYes.setImage(uncheckedImage, for: UIControl.State.normal)
    }
    
    @IBAction func txtRXActive(_ sender: Any) {
        layer2.frame = CGRect(origin: CGPoint(x: 1, y:txtRX.frame.height), size: CGSize(width: txtRX.frame.width, height: 1))
        txtRX.layer.addSublayer(layer2)
    }
    @IBAction func txtRXInactive(_ sender: Any) {
        layer.removeFromSuperlayer()
    }
    @IBAction func txtPharmNameActive(_ sender: Any) {
        layer2.frame = CGRect(origin: CGPoint(x: 1, y:txtpharmName.frame.height), size: CGSize(width: txtpharmName.frame.width, height: 1))
        txtpharmName.layer.addSublayer(layer2)
    }
    @IBAction func txtPharmNameInactive(_ sender: Any) {
        layer.removeFromSuperlayer()
    }
    @IBAction func txtPharmNumActive(_ sender: Any) {
        layer2.frame = CGRect(origin: CGPoint(x: 1, y:txtpharmNumber.frame.height), size: CGSize(width: txtpharmNumber.frame.width, height: 1))
        txtpharmNumber.layer.addSublayer(layer2)
    }
    @IBAction func txtPharmNumInactive(_ sender: Any) {
        layer.removeFromSuperlayer()
    }
    @IBAction func medPressed(_ sender: Any) {
    if viewTypes.isHidden {
       
        
        viewTypes.isHidden = false
       
        viewTypes.isExclusiveTouch = true
        delivery.isHidden = false
        
        deliveryTypeLabel.isExclusiveTouch = true
        
        }}
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deliveryTypeLabel.text = types[row]
        delivery.isHidden = true
        viewTypes.isHidden = true
    }
}
