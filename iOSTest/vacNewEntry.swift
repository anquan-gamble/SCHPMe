//
//  vacNewEntry.swift
//  iOSTest
//
//  Created by FMU-SCRA on 12/12/20.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import UIKit
import SQLite3
import Toast_Swift
import FMDB


class VaccinationEntry: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var viewTypes: UIView!
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var vaccinations: UIPickerView!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var vacTypeButton: UIButton!
    
    @IBOutlet weak var txtDateBox: UITextField!
    
    @IBOutlet weak var vacTypeLabel: UILabel!
    var typeString: String!
    var dateString: String!
    
    @IBOutlet weak var yes: UILabel!
    
    let types = ["Flu Shot","Shingrix (RZV)", "Prevnar 13", "Pneumovax 23", "Tetanus (TD)", "Heplisav-B (Dose 1)", "Heplisav-B (Dose 2)", "Heplisav-B (Dose 3)", "Engerix-B (Dose 1)", "Engerix-B (Dose 2)", "Engerix-B (Dose 3)", "Recombivax HB (Dose 1)", "Recombivax HB (Dose 2)", "Recombivax HB (Dose 3)"]
    
    var pickerView = UIPickerView()
    var vDelegate: VDataDelegate?
    
    @IBAction func enter(_ sender: UIButton) {
        insertDB()
    }
    
    @IBAction func Clear(_ sender: UIButton) {

        txtDateBox.text = nil
    }
    func insertDB() {
        let vt = vacTypeLabel.text
        
        let stat = yes.text
    let date = txtDateBox.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        let qstate = "INSERT INTO VaccTable (vaccination, status, date) values (?,?,?);"
        if (vt?.isEmpty)! || (date?.isEmpty)!  {
            self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
            return;
        }
            do {
                try database.executeUpdate(qstate, values: [vt!, stat!, date!])
                print("idk")
                
                self.view.makeToast("Vaccination Entered", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_checkmark.png"))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.dismiss(animated: true,completion: nil)
                }
               
        }
            catch {
                print("\(error.localizedDescription)")
            }
        
        database.close()
        vDelegate?.getVData()
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        vaccinations.isHidden = true
        vaccinations.delegate = self
        vaccinations.dataSource = self
        
    }

    @IBAction func vacPressed(_ sender: Any) {
        if viewTypes.isHidden {
           
            
            viewTypes.isHidden = false
           
            viewTypes.isExclusiveTouch = true
            vaccinations.isHidden = false
            
            vacTypeLabel.isExclusiveTouch = true
            
        }
      //  typeString = pickerView.
     //   vacTypeLabel.text = typeString
        
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
    @IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goHome(_ sender: Any) {
        performSegue(withIdentifier: "goHomeVacEntry", sender: self)
    }
    
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
        vacTypeLabel.text = types[row]
        vaccinations.isHidden = true
        viewTypes.isHidden = true
    }
}

