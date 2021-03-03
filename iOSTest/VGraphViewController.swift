//
//  VGraphViewController.swift
//  iOSTest
//
//  Created by FMU-SCRA on 12/14/20.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import FMDB

protocol VDataDelegate {
    func getVData()
}
class VaccinationChartViewController: UIViewController, VDataDelegate {
    
    

    @IBOutlet weak var vps: UITableView!
    var vArray = [VData]()
    var vDelegate: VDataDelegate?
    var vTypes: [String] = []
    var vX = [VData]()
  //  let types = ["Flu Shot","Shingrix (RZV)", "Prevnar 13", "Pneumovax 23", "Tetanus (TD)", "Heplisav-B (Dose 1)", "Heplisav-B (Dose 2)", "Heplisav-B (Dose 3)", "Engerix-B (Dose 1)", "Engerix-B (Dose 2)", "Engerix-B (Dose 3)", "Recombivax HB (Dose 1)", "Recombivax HB (Dose 2)", "Recombivax HB (Dose 3)"]
  //  var entry = VaccinationEntry()
    func getVData() {
            getAllVData()
        }
    func getAllVData() {
            let myURL = fileUrl
                print(myURL)
                vArray.removeAll()
            let database = FMDatabase(url: fileUrl)
            if database.open() {
                do {
                    let rs = try database.executeQuery("select * from VaccTable", values: nil)
                    while rs.next() {
                        let items : VData = VData()
                        items.id = rs.string(forColumn: "id")
                        items.vaccination = rs.string(forColumn: "vaccination")
                       
                    items.status = rs.string(forColumn: "status")
                        items.date = rs.string(forColumn: "date")
                
                        vArray.append(items)
                        vTypes.append(String(items.vaccination!))
                            
                        print(vTypes)

                        }
                    vps.delegate = self
                    vps.dataSource = self
                    vps.reloadData()
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
                  //getAllVData()
        vps.delegate = self
        vps.dataSource = self

    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension VaccinationChartViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // vTypes.append(contentsOf: types)
        return vArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
           
              let cell = vps.dequeueReusableCell(withIdentifier: "VCell", for: indexPath) as! VCell

               tableView.separatorColor = UIColor.white
        let obj = vArray[indexPath.row]

        cell.configureV(dict: obj)
               return cell
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dataV = self.vArray[indexPath.row]
        let cellID = dataV.id
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, scrollview, completionHandler) in
            let database = FMDatabase(url: fileUrl)
            guard database.open() else {
                print("Not fetch database")
                return
            }
            do {
                _ =  database.executeUpdate("delete from VaccTable where id =? ", withArgumentsIn: [cellID!])
            }
            catch let err {
                print(err.localizedDescription)
            }
            database.close()
            
            
            self.vTypes.removeAll()
            self.getVData()
            
            completionHandler(true)
        }
        delete.backgroundColor = UIColor.red
        let swipeConfigure = UISwipeActionsConfiguration(actions: [delete])
        swipeConfigure.performsFirstActionWithFullSwipe = false
        return swipeConfigure
    }
}

class VCell:UITableViewCell {
    @IBOutlet weak var lblvaccination: UILabel!
    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    func configureV(dict: VData) {
        lblvaccination.text = dict.vaccination
        lblstatus.text = dict.status
        lbldate.text = dict.date
    }
}



