//
//  AGraphViewController.swift
//  iOSTest
//
//  Created by FMU-SCRA on 11/1/20.
//  Copyright © 2020 Anquan Gamble. All rights reserved.
//

import FMDB

protocol ADataDelegate {
    func getAData()
}
class AllergyChartViewController: UIViewController, ADataDelegate {
    @IBOutlet weak var aps: UITableView!
    var aArray = [AData]()
    var aDelegate: ADataDelegate?
    var aNames: [String] = []
    var aReactions: [String] = []
    var aX = [AData]()
    
    
    
    func getAData() {
        getAllAData()
    }
    func getAllAData() {
        let myURL = fileUrl
        print(myURL)
        aArray.removeAll()
        let database = FMDatabase(url: fileUrl)
        if database.open() {
            do {
                let rs = try database.executeQuery("select * from ATable", values: nil)
                while rs.next() {
                    let items : AData = AData()
                    items.id = rs.string(forColumn: "id")
                    items.allergyName = rs.string(forColumn: "allergyName")
                    items.allergyReaction = rs.string(forColumn: "allergyReaction")
        
                   aArray.append(items)
                    aNames.append((items.allergyName!))
                    aReactions.append((items.allergyReaction!))
                    print(aNames)
                    print(aReactions)
                }
                aps.delegate = self
                aps.dataSource = self
                aps.reloadData()
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
               getAllAData()
           }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension AllergyChartViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
           
              let cell = aps.dequeueReusableCell(withIdentifier: "ACell", for: indexPath) as! ACell
               tableView.separatorColor = UIColor.white
              let obj = aArray[indexPath.row]
               cell.configureA(dict: obj)
               return cell
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dataA = self.aArray[indexPath.row]
        let cellID = dataA.id
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, scrollview, completionHandler) in
            let database = FMDatabase(url: fileUrl)
            guard database.open() else {
                print("Not fetch database")
                return
            }
            do {
                _ =  database.executeUpdate("delete from ATable where id =? ", withArgumentsIn: [cellID!])
            }
            catch let err {
                print(err.localizedDescription)
            }
            database.close()
            
            self.aNames.removeAll()
            self.aReactions.removeAll()
            self.getAData()
            
            completionHandler(true)
        }
        delete.backgroundColor = UIColor.red
        let swipeConfigure = UISwipeActionsConfiguration(actions: [delete])
        swipeConfigure.performsFirstActionWithFullSwipe = false
        return swipeConfigure
    }
}
class ACell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblReaction: UILabel!
    func configureA(dict: AData) {
        lblName.text = dict.allergyName
        lblReaction.text = dict.allergyReaction
    }
}
