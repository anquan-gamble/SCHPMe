//
//  ViewController.swift
//  iOSTest
//
//  Created by Aaron Fulmer on 1/17/20.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import UIKit
import SQLite3
import Toast_Swift
import FMDB

class AllergyEntry: UIViewController{

    @IBOutlet weak var txtAllergyName: UITextField!
    @IBOutlet weak var txtAllergyReaction: UITextField!
    @IBOutlet var layer: CALayer!
    @IBOutlet var layer2: CALayer!
    var aDelegate: ADataDelegate?

    
    
    func insertDB() {
        
        let name = txtAllergyName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let reaction = txtAllergyReaction.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let database  = FMDatabase(url: fileUrl)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        let qstate = "INSERT INTO ATable (allergyName, allergyReaction) values (?,?);"
        if (name?.isEmpty)! || (reaction?.isEmpty)! {
            self.view.makeToast("Please Complete All Fields", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_warning.png"))
            return;
        }
            do {
                try database.executeUpdate(qstate, values: [name!, reaction!])
                print("idk")
                
                self.view.makeToast("Allergy Entered", duration: 2, position: .center, title: nil, image: UIImage(named: "ic_checkmark.png"))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.dismiss(animated: true,completion: nil)
                }
               
        }
            catch {
                print("\(error.localizedDescription)")
            }
        
        database.close()
        aDelegate?.getAData()
        self.navigationController?.popViewController(animated: true)
    }
    
    
        
    @IBAction func Enter(_ sender: Any) {
        insertDB()
    }
    @IBAction func Clear(_ sender: Any) {
        txtAllergyName.text = nil
        txtAllergyReaction.text = nil
    }
    
    @IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gohome(_ sender: Any) {
        performSegue(withIdentifier: "goHomeAEntry", sender: self)
    }
        
    
    @IBAction func txtNameActive(_ sender: Any) {
        if layer != nil {
        layer2.frame = CGRect(origin: CGPoint(x: 1, y:txtAllergyName.frame.height), size: CGSize(width: txtAllergyName.frame.width, height: 1))
        txtAllergyName.layer.addSublayer(layer)
        }
    }
    @IBAction func txtNameInactive(_ sender: Any) {
        if layer != nil {
        layer.removeFromSuperlayer()
        }
    }
    @IBAction func txtReactionActive(_ sender: Any) {
        //self.txtAllergyReaction.becomeFirstResponder()
        if layer2 != nil {
        layer2.frame = CGRect(origin: CGPoint(x: 0, y:txtAllergyReaction.frame.height), size: CGSize(width: txtAllergyReaction.frame.width, height: 2))
        txtAllergyReaction.layer.addSublayer(layer2)
            //self.txtAllergyReaction.becomeFirstResponder()
        }
    }
    @IBAction func txtReactionInactive(_ sender: Any) {
        //self.txtAllergyReaction.resignFirstResponder()
        if layer2 != nil {
        layer2.removeFromSuperlayer()
        }
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AllergyEntry.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap() {
        view.endEditing(true)
    }
    private func configureTextFields() {
        txtAllergyName.delegate = self
        txtAllergyReaction.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     // Do any additional setup after loading the view.
       // self.toolBar()
        configureTextFields()
        configureTapGesture()
        
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtAllergyName.frame.height), size: CGSize(width: txtAllergyName.frame.width, height: 1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtAllergyName.borderStyle = UITextField.BorderStyle.none
        txtAllergyName.layer.addSublayer(bottomLine)
        bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:txtAllergyReaction.frame.height), size: CGSize(width: txtAllergyReaction.frame.width, height: 1))
        bottomLine.backgroundColor = UIColor(red: 28/255.0, green: 103/255.0, blue: 106/255.0, alpha: 1.0).cgColor
        txtAllergyReaction.borderStyle = UITextField.BorderStyle.none
        txtAllergyReaction.layer.addSublayer(bottomLine)
    }

}
extension AllergyEntry: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
