//
//  EditProfileViewController.swift
//  iOSTest
//
//  Created by FMU-SCRA on 1/13/21.
//  Copyright © 2021 Aaron Fulmer. All rights reserved.
//

import Foundation
import FMDB

protocol  UPDataDelegate {
    func getUPData()
}

class UPViewController: UIViewController, UPDataDelegate{

    
    @IBOutlet weak var UPT: UITableView!
    
    @IBAction func PrivacyPolicy(_ sender: UIButton) {
        if let url = NSURL(string: "https://www.schealthplusme.com/privacy"){
            UIApplication.shared.openURL(url as URL)
        }
    }

    var upArray = [UPData]()
    var upDelegate: UPDataDelegate?
    var fNames: [String] = []
    var lNames: [String] = []
    var upX = [UPData]()
    
    func getUPData() {
        getAllUPData()
        
    }
    
    func getAllUPData() {
        let myURL = fileUrl
        print(myURL)
        upArray.removeAll()
        let database = FMDatabase(url: fileUrl)
        if database.open() {
            do {
                let rs = try database.executeQuery("select * from UPTable", values: nil)
            
                while rs.next() {
                    let items : UPData = UPData()
                
                    items.id = rs.string(forColumn: "id")
                    items.firstName = rs.string(forColumn: "firstName")
                    items.lastName = rs.string(forColumn: "lastName")
                    items.gender = rs.string(forColumn: "gender")
                    items.date = rs.string(forColumn: "date")
                upArray.append(items)
                fNames.append(items.firstName!)
                lNames.append(items.lastName!)
                print(fNames)
                print(lNames)
                }
                UPT.delegate = self
                UPT.dataSource = self
                UPT.reloadData()
            }
                catch {
                    print("error:\(error.localizedDescription)")
                }
        }
            else {
                print("Unable to open database")
                return
            }
            database.close()
    }
    override func viewDidLoad() {
               super.viewDidLoad()
               getAllUPData()
               
        
           }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension UPViewController: UITableViewDelegate, UITableViewDataSource {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return upArray.count
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
           
    let cell = UPT.dequeueReusableCell(withIdentifier: "UPCell", for: indexPath) as! UPCell
               tableView.separatorColor = UIColor.clear
              let obj = upArray[indexPath.row]
               cell.configureUP(dict: obj)
               return cell
    }
    
}
class UPCell: UITableViewCell {
   
    @IBOutlet weak var lblFN: UILabel!
    
    @IBOutlet weak var lblLN: UILabel!
    
    @IBOutlet weak var lblDOB: UILabel!
    
    @IBOutlet weak var lblSex: UILabel!
    
    func configureUP(dict: UPData){
        lblFN.text = dict.firstName
        lblLN.text = dict.lastName
        lblDOB.text = dict.date
        lblSex.text = dict.gender
    }
    
}
