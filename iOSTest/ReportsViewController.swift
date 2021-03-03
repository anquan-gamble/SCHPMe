//
//  ReportsViewController.swift
//  iOSTest
//
//  Created by FMU-SCRA on 1/21/21.
//  Copyright © 2021 Aaron Fulmer. All rights reserved.
//

import FMDB

protocol RDataDelegate {
    func getRData()
}

class ReportsViewController: UIViewController, RDataDelegate {
    @IBOutlet weak var rps: UITableView!
    @IBOutlet weak var rbpps: UITableView!
    @IBOutlet weak var rbsps: UITableView!
    @IBOutlet weak var rchps: UITableView!
    @IBOutlet weak var rvaps: UITableView!
    @IBOutlet weak var rbwps: UITableView!
    
    
    var maxRows = 10
    var maxSections = 8
    
    
    func getRData() {
        getAllRData()
    }
    
    var bpArray = [BPData]()
    var syst: [Double] = []
    var dias: [Double] = []
    var bpDelegate: BPDataDelegate?
    
    var bsArray = [BSData]()
    var bloodSL: [Double] = []
    var bsDelegate: BSDataDelegate?
    
    var chArray = [CHData]()
    var totalC: [Double] = []
    var highDL: [Double] = []
    var triglycerides: [Double] = []
    var lowDL: [Double] = []
    var chDelegate: CHDataDelegate?
    
    var vArray = [VData]()
    var vTypes: [String] = []
    var vDelegate: VDataDelegate?
    
    var bwArray = [BWData]()
    var weigh: [Double] = []
    var bwDelegate: BWDataDelegate?
    
    var reportsArray = [Int]()
    
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        getAllRData()
        //self.tableRead()

        reportsArray = [bpArray.count + bsArray.count + bwArray.count + vArray.count + chArray.count]
    }
    
    func getAllRData() {
        let myURL = fileUrl
        print(myURL)
        bpArray.removeAll()
        bsArray.removeAll()
        let database = FMDatabase(url: fileUrl)
        if database.open() {
            /*
            do {
                let rs = try database.executeQuery("select * from BPTable order by date, time", values: nil)
                
                let rs1 = try database.executeQuery("select * from BloodSTable11 order by date, time", values: nil)
                let rs2 = try database.executeQuery("select * from CTable order by date, time", values: nil)
                let rs3 = try database.executeQuery("select * from VaccTable", values: nil)
                let rs4 = try database.executeQuery("select * from BWTable", values: nil)
                
                while rs.next() && rs1.next() && rs2.next() && rs3.next() && rs4.next() {
                    let items : BPData = BPData()
                    
                    items.id = rs.string(forColumn: "id")
                    items.systolic = rs.string(forColumn: "systolic")
                    items.diastolic = rs.string(forColumn: "diastolic")
                    items.date = rs.string(forColumn: "date")
                    items.time = rs.string(forColumn: "time")
                    
                    bpArray.append(items)
                    syst.append(Double(items.systolic!)!)
                    dias.append(Double(items.diastolic!)!)
                    
                    print(syst)
                    
                    print(dias)
                    
                    
                    let items1 : BSData = BSData()
                    items1.id = rs1.string(forColumn: "id")
                    items1.bloodSugarLevel = rs1.string(forColumn: "bloodSugarLevel")
                    items1.fast = rs1.string(forColumn: "fast")

                    items1.date = rs1.string(forColumn: "date")
                    items1.time = rs1.string(forColumn: "time")
                    bsArray.append(items1)
                    bloodSL.append(Double(items1.bloodSugarLevel!)!)
                    print(bloodSL)
                    
                
                    let items2 : CHData = CHData()
                    items2.id = rs2.string(forColumn: "id")
                    items2.TC = rs2.string(forColumn: "TC")
                    items2.HDL = rs2.string(forColumn: "HDL")
                    items2.TRIG = rs2.string(forColumn: "TRIG")
                    items2.LDL = rs2.string(forColumn: "LDL")
                    items2.date = rs.string(forColumn: "date")
                    items2.time = rs.string(forColumn: "time")
                    chArray.append(items2)
                    totalC.append(Double(items2.TC!)!)
                    highDL.append(Double(items2.HDL!)!)
                    triglycerides.append(Double(items2.TRIG!)!)
                    lowDL.append(Double(items2.LDL!)!)
                    print(totalC)
                    print(highDL)
                    print(triglycerides)
                    print(lowDL)
                    
                let items3 : VData = VData()
                items3.id = rs3.string(forColumn: "id")
                items3.vaccination = rs3.string(forColumn: "vaccination")
                items3.status = rs3.string(forColumn: "status")
                items3.date = rs3.string(forColumn: "date")
                    vArray.append(items3)
                    vTypes.append(String(items3.vaccination!))
                    print(vTypes)
                
                let items4 : BWData = BWData()
                items4.id = rs4.string(forColumn: "id")
                items4.weight = rs4.string(forColumn: "weight")
                items4.date = rs4.string(forColumn: "date")
                items4.time = rs4.string(forColumn: "time")
                bwArray.append(items4)
                
                weigh.append(Double(items4.weight!)!)
                print(weigh)
 
                }
                rps.delegate = self
                rps.dataSource = self
                rps.reloadData()
                /*
                rbpps.delegate = self
                rbpps.dataSource = self
                rbpps.reloadData()
                rbsps.delegate = self
                rbsps.dataSource = self
                rbsps.reloadData()
                rchps.delegate = self
                rchps.dataSource = self
                rchps.reloadData()
                rvaps.delegate = self
                rvaps.dataSource = self
                rvaps.reloadData()
                rbwps.delegate = self
                rbwps.dataSource = self
                rbwps.reloadData() */
            }
            catch {
                print("error:\(error.localizedDescription)")
            } */
            do {
                let rs = try database.executeQuery("select * from BPTable order by date, time", values: nil)
                let items : BPData = BPData()
                while rs.next() {
                items.id = rs.string(forColumn: "id")
                items.systolic = rs.string(forColumn: "systolic")
                items.diastolic = rs.string(forColumn: "diastolic")
                items.date = rs.string(forColumn: "date")
                items.time = rs.string(forColumn: "time")
                
                bpArray.append(items)
                syst.append(Double(items.systolic!)!)
                dias.append(Double(items.diastolic!)!)
                
                print(syst)
                
                print(dias)
                    
                }
                rps.delegate = self
                rps.dataSource = self
                rps.reloadData()
            }
            catch {
                    print("error:\(error.localizedDescription)")
                }
            
            
            
            do {
                let rs1 = try database.executeQuery("select * from BloodSTable11 order by date, time", values: nil)
                while rs1.next() {
                    let items1 : BSData = BSData()
                    items1.id = rs1.string(forColumn: "id")
                    items1.bloodSugarLevel = rs1.string(forColumn: "bloodSugarLevel")
                    items1.fast = rs1.string(forColumn: "fast")

                    items1.date = rs1.string(forColumn: "date")
                    items1.time = rs1.string(forColumn: "time")
                    bsArray.append(items1)
                    bloodSL.append(Double(items1.bloodSugarLevel!)!)
                    print(bloodSL)
                }
            }
            catch {
                    print("error:\(error.localizedDescription)")
                }
            
            do {
                let rs2 = try database.executeQuery("select * from CTable order by date, time", values: nil)
                while rs2.next() {
                    let items2 : CHData = CHData()
                    items2.id = rs2.string(forColumn: "id")
                    items2.TC = rs2.string(forColumn: "TC")
                    items2.HDL = rs2.string(forColumn: "HDL")
                    items2.TRIG = rs2.string(forColumn: "TRIG")
                    items2.LDL = rs2.string(forColumn: "LDL")
                    items2.date = rs2.string(forColumn: "date")
                    items2.time = rs2.string(forColumn: "time")
                    chArray.append(items2)
                    totalC.append(Double(items2.TC!)!)
                    highDL.append(Double(items2.HDL!)!)
                    triglycerides.append(Double(items2.TRIG!)!)
                    lowDL.append(Double(items2.LDL!)!)
                    print(totalC)
                    print(highDL)
                    print(triglycerides)
                    print(lowDL)
                }
            }
            catch {
                print("error:\(error.localizedDescription)")
                
            }
            
            do {
                let rs3 = try database.executeQuery("select * from VaccTable", values: nil)
                while rs3.next() {
                    let items3 : VData = VData()
                    items3.id = rs3.string(forColumn: "id")
                    items3.vaccination = rs3.string(forColumn: "vaccination")
                    items3.status = rs3.string(forColumn: "status")
                    items3.date = rs3.string(forColumn: "date")
                        vArray.append(items3)
                        vTypes.append(String(items3.vaccination!))
                        print(vTypes)
                }
            }
            catch {
                print("error:\(error.localizedDescription)")
            }
            
            do {
                let rs4 = try database.executeQuery("select * from BWTable", values: nil)
                while rs4.next() {
                    let items4 : BWData = BWData()
                    items4.id = rs4.string(forColumn: "id")
                    items4.weight = rs4.string(forColumn: "weight")
                    items4.date = rs4.string(forColumn: "date")
                    items4.time = rs4.string(forColumn: "time")
                    bwArray.append(items4)
                    
                    weigh.append(Double(items4.weight!)!)
                    print(weigh)
                }
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
    
}
extension ReportsViewController: UITableViewDelegate, UITableViewDataSource {
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
        
        /*
        rps.allowsMultipleSelection = true
        var numberOfRow = 1
        switch tableView {
        case rps:
            numberOfRow = bpArray.count
            numberOfRow = bsArray.count
            numberOfRow = chArray.count
            numberOfRow = bwArray.count
            /*
        case rbsps:
            numberOfRow = bsArray.count
        case rchps:
            numberOfRow = chArray.count
        case rvaps:
            numberOfRow = vArray.count
        case rbwps:
            numberOfRow = bwArray.count
 */
        default:
            print("ERROR")
        }
        
        return numberOfRow
 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell = rps.dequeueReusableCell(withIdentifier: "RCell", for: indexPath) as! RCell
        cell.textLabel?.text = String(format: "Section %i, Row %i", indexPath.section, indexPath.row)
        cell.backgroundColor = cellColorForIndex(indexPath: indexPath as NSIndexPath)
        return cell
        */
        
        var cell = RCell()
        switch tableView {
        case rps:
            cell = rps.dequeueReusableCell(withIdentifier: "RCell", for: indexPath) as! RCell
            cell.layer.borderColor = UIColor.red.cgColor
            cell.layer.borderWidth = 2
            //cell.layer.cornerRadius = 10
            cell.clipsToBounds = false
            let obj1 = bpArray[indexPath.row]
             cell.configureBP(dict: obj1)
            let obj2 = bsArray[indexPath.row]
            cell.configureBS(dict: obj2)
            let obj3 = chArray[indexPath.row]
            cell.configureCH(dict: obj3)
            let obj4 = vArray[indexPath.row]
            cell.configureV(dict: obj4)
            let obj5 = bwArray[indexPath.row]
            cell.configureBW(dict: obj5)
         
            /*
        case rbsps:
            cell = rbsps.dequeueReusableCell(withIdentifier: "RCell", for: indexPath) as! RCell
            cell.layer.borderColor = UIColor.red.cgColor
            cell.layer.borderWidth = 2
            //cell.layer.cornerRadius = 10
            cell.clipsToBounds = false
            let obj = bsArray[indexPath.row]
             cell.configureBS(dict: obj)
        case rchps:
            cell = rchps.dequeueReusableCell(withIdentifier: "RCell", for: indexPath) as! RCell
                   //tableView.separatorColor = UIColor.white
            cell.layer.borderColor = UIColor.brown.cgColor
            cell.layer.borderWidth = 4
            //cell.layer.cornerRadius = 10
            cell.clipsToBounds = false
                  let obj = chArray[indexPath.row]
                   cell.configureCH(dict: obj)
        case rvaps:
            cell = rvaps.dequeueReusableCell(withIdentifier: "RCell", for: indexPath) as! RCell

                   tableView.separatorColor = UIColor.white
            let obj = vArray[indexPath.row]

            cell.configureV(dict: obj)
        case rbwps:
            cell = rbwps.dequeueReusableCell(withIdentifier: "RCell", for: indexPath) as! RCell
             cell.layer.borderColor = UIColor.white.cgColor
             cell.layer.borderWidth = 2
             
             cell.clipsToBounds = false
            let obj = bwArray[indexPath.row]
             cell.configureBW(dict: obj)
 */
        default:
            print("Something wrong")
        }
      /*  let cell = rbpps.dequeueReusableCell(withIdentifier: "RBPCell", for: indexPath) as! RBPCell

        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 2
        //cell.layer.cornerRadius = 10
        cell.clipsToBounds = false
        let obj = bpArray[indexPath.row]
         cell.configureBP(dict: obj)
 */
         return cell
 
    }
    
    
    func cellColorForIndex(indexPath: NSIndexPath) -> UIColor {
        let row = CGFloat(indexPath.row)
        let section = CGFloat(indexPath.section)
        
        let saturation = 1.0 - row / CGFloat(maxRows)
        let hue = section / CGFloat(maxSections)
        
        return UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
    }
    
    
    
 /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rbsps.dequeueReusableCell(withIdentifier: "RBSCell", for: indexPath) as! RBSCell

        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 2
        //cell.layer.cornerRadius = 10
        cell.clipsToBounds = false
        let obj = bsArray[indexPath.row]
         cell.configureBS(dict: obj)
         return cell
    }
 
    */
}
class RCell: UITableViewCell {
    @IBOutlet weak var lblSys: UILabel!
    @IBOutlet weak var lblDia: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    
    func configureBP(dict: BPData) {
        lblSys.numberOfLines = 3
        lblSys.text = dict.systolic!.appending("\n").appending(dict.systolic!)
    lblDia.text = dict.diastolic
    lblDate.text = dict.date
        
        
    }
    
    @IBOutlet weak var lblBSL: UILabel!
    @IBOutlet weak var lblfast: UILabel!
    @IBOutlet weak var lblDate2: UILabel!
    func configureBS(dict: BSData) {
        lblBSL.text = dict.bloodSugarLevel
    lblfast.text = dict.fast
    lblDate2.text = dict.date
    }
    
    @IBOutlet weak var lblTC: UILabel!
    @IBOutlet weak var lblHDL: UILabel!
    @IBOutlet weak var lblTRIG: UILabel!
    @IBOutlet weak var lblLDL: UILabel!
    @IBOutlet weak var lblDate3:UILabel!
    func configureCH(dict: CHData){
    lblTC.text = dict.TC
    lblHDL.text = dict.HDL
    lblTRIG.text = dict.TRIG
    lblLDL.text = dict.LDL
    lblDate3.text = dict.date
    }
    
    @IBOutlet weak var lblvaccination: UILabel!
    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var lblDate4: UILabel!
    func configureV(dict: VData) {
        lblvaccination.text = dict.vaccination
        lblstatus.text = dict.status
        lblDate4.text = dict.date
    }
    
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblDate5: UILabel!
    func configureBW(dict: BWData) {
    lblWeight.text = dict.weight
    lblDate5.text = dict.date
    }
}
