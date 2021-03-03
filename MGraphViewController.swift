//
//  MGraphViewController.swift
//  iOSTest
//
//  Created by FMU-SCRA on 12/17/20.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import FMDB

protocol MDataDelegate {
    func getMData()
}
class MedicationsChartViewController: UIViewController, MDataDelegate {
    @IBOutlet weak var mps: UITableView!

    var mArray = [MData]()
    var mDelegate: MDataDelegate?
    var mTypes: [Double] = []
    var mX = [VData]()
    

    @IBAction func Help(_ sender: UIButton) {
        let dialogMessage = UIAlertController(title: "Help Window ", message: "To call pharmacy, swipe cell to the right. \n To delete an entry, swipe cell to the left. \n To up the the status of the medication, click on the cell.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {(action) -> Void in print("Cancel button tapped ")}
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
   
    
    func getMData() {
            getAllMData()
        }
    func getAllMData() {
                let myURL = fileUrl
                    print(myURL)
                    mArray.removeAll()
                let database = FMDatabase(url: fileUrl)
                if database.open() {
                    do {
                        let rs = try database.executeQuery("select * from MedTable", values: nil)
                        while rs.next() {
                            let items : MData = MData()
                            items.id = rs.string(forColumn: "id")
                            items.medName = rs.string(forColumn: "medName")
                            items.medDosage = rs.string(forColumn: "medDosage")
                            items.dosageFrequency = rs.string(forColumn: "dosageFrequency")
                            items.medDelivery = rs.string(forColumn: "medDelivery")
                            items.takingStatus = rs.string(forColumn: "takingStatus")
                            items.rxNumber = rs.string(forColumn: "rxNumber")
                            items.pharmName = rs.string(forColumn: "pharmName")
                            items.pharmNumber = rs.string(forColumn: "pharmNumber")
                            
                            mArray.append(items)
                            mTypes.append(Double(items.pharmNumber!)!)
                            print(mTypes)
                        }
                        mps.delegate = self
                        mps.dataSource = self
                        mps.reloadData()
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
                      getAllMData()
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    
    }

extension MedicationsChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return mArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mps.dequeueReusableCell(withIdentifier: "MCell", for: indexPath) as! MCell
         tableView.separatorColor = UIColor.white
        let obj = mArray[indexPath.row]
         cell.configureM(dict: obj)
        
         return cell
    }
    

    
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               
        let cell = mps.dequeueReusableCell(withIdentifier: "MCell", for: indexPath) as! MCell
                   tableView.separatorColor = UIColor.white
                  let obj = mArray[indexPath.row]
                   cell.configureM(dict: obj)
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(self.switchDidChange(_:)), for: .valueChanged)
        cell.accessoryView = switchView
                   return cell
        }
    @objc func switchDidChange(_ sender: UISwitch){
        print("sender is \(sender.tag)")
    }*/
    //var PopUpViewController:PopUpViewController?

        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dialogMessage = UIAlertController(title: "Medication Status: ", message: "Are you still taking this medication", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Taking", style: .default, handler:  { (action) -> Void in print("Ok button tapped")
                let dataM = self.mArray[indexPath.row]
                let cellID = dataM.id
                
                let database = FMDatabase(url: fileUrl)
                if database.open() {
                 
                        do {
                            
                            _ = database.executeUpdate("UPDATE MedTable SET takingStatus = 'Yes' where id =? ", withArgumentsIn: [cellID!])
                            
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
                self.getAllMData()
        })
            let cancel = UIAlertAction(title: "Not Taking", style: .default, handler:  { (action) -> Void in print("Ok button tapped")
                    let dataM = self.mArray[indexPath.row]
                    let cellID = dataM.id
                    
                    let database = FMDatabase(url: fileUrl)
                    if database.open() {
                     
                            do {
                                
                                _ = database.executeUpdate("UPDATE MedTable SET takingStatus = 'No' where id =? ", withArgumentsIn: [cellID!])
                                
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
                self.getAllMData()
            })
            dialogMessage.addAction(cancel)
            dialogMessage.addAction(ok)
            
            self.present(dialogMessage, animated: true, completion: nil)
            
    }
    
        /*let dataM = self.mArray[indexPath.row]
        let cellID = dataM.id
        let database = FMDatabase(url: fileUrl)
        let phoneNumber = database.executeUpdate("Select pharmNumber from MTable where id =? ", withArgumentsIn: [cellID!])
        
                   return phoneNumber*/
        /*UIApplication.shared.openURL(NSURL(string: "tel://" + (mArray[indexPath.row].pharmNumber?.description)!)! as URL)
        print(mArray[indexPath.row].pharmNumber?.description)
        */
        
        

        
  
        @available(iOS 11.0, *)
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let dataM = self.mArray[indexPath.row]
            let cellID = dataM.id
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, scrollview, completionHandler) in
                let database = FMDatabase(url: fileUrl)
                guard database.open() else {
                    print("Not fetch database")
                    return
                }
                do {
                    _ =  database.executeUpdate("delete from MedTable where id =? ", withArgumentsIn: [cellID!])
                }
                catch let err {
                    print(err.localizedDescription)
                }
                database.close()
                
                
                self.mTypes.removeAll()
                self.getMData()
                
                completionHandler(true)
            }
            delete.backgroundColor = UIColor.red
            let swipeConfigure = UISwipeActionsConfiguration(actions: [delete])
            swipeConfigure.performsFirstActionWithFullSwipe = false
            return swipeConfigure
        }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let dataM = self.mArray[indexPath.row]
        let cellID = dataM.id
        let call = UIContextualAction(style: .destructive, title: "Call") { (action, scrollview, completionHandler) in
            let database = FMDatabase(url: fileUrl)
            guard database.open() else {
                print("Not fetch database")
                return
            }
            do {
                _ =  database.executeUpdate("Select pharmNumber from MedTable where id =? ", withArgumentsIn: [cellID!])
            }
            catch let err {
                print(err.localizedDescription)
            }
            database.close()
            
            
            self.mTypes.removeAll()
            self.getMData()
            
            completionHandler(true)
        }
        call.backgroundColor = UIColor.green
        let swipeConfigure = UISwipeActionsConfiguration(actions: [call])
        swipeConfigure.performsFirstActionWithFullSwipe = false
        UIApplication.shared.openURL(NSURL(string: "tel://" + (mArray[indexPath.row].pharmNumber?.description)!)! as URL)
        print(mArray[indexPath.row].pharmNumber?.description)
        return swipeConfigure
    }
}
class MCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDosage: UILabel!
    
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    
    @IBOutlet weak var lblRX: UILabel!
    
    @IBOutlet weak var lblPharm: UILabel!
    
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var lblTaking: UILabel!
    
    
    func configureM(dict:MData) {
        lblName.text = dict.medName
        lblDosage.text = dict.medDosage
        lblFrequency.text = dict.dosageFrequency
        lblDelivery.text = dict.medDelivery
        lblRX.text = dict.rxNumber
        lblPharm.text = dict.pharmName
        lblPhone.text = dict.pharmNumber
        lblTaking.text = dict.takingStatus
    }
}

