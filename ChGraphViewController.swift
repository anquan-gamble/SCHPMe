//
//  ChGraphViewController.swift
//  iOSTest
//
//  Created by Garriss Moseley on 4/24/20.
//  Copyright © 2020 Garriss Moseley. All rights reserved.
//
//  This file controls the graph functions/design for the body weight readings
//  Temporary values are hardcoded here to test the functionality of the graph


import Charts
import FMDB

protocol CHDataDelegate {
    func getCHData()
}

class ChChartsViewController: UIViewController, CHDataDelegate
{
    @IBOutlet weak var ChChartView: LineChartView!
    @IBOutlet weak var chps: UITableView!
    var chArray = [CHData]()
    var chDelegate: CHDataDelegate?
    var totalC: [Double] = []
    var highDL: [Double] = []
    var triglycerides: [Double] = []
    var lowDL: [Double] = []
    var chX = [CHData]()
    let cellSpacingHeight: CGFloat = 5
    
    
    func getCHData() {
        getAllCHData()
    }
    func getAllCHData() {
        let myURL = fileUrl
        print(myURL)
        chArray.removeAll()
        let database = FMDatabase(url: fileUrl)
        if database.open() {
            do {
                let rs = try database.executeQuery("select * from CTable order by date, time", values: nil)
                while rs.next() {
                    let items : CHData = CHData()
                    items.id = rs.string(forColumn: "id")
                    items.TC = rs.string(forColumn: "TC")
                    items.HDL = rs.string(forColumn: "HDL")
                    items.TRIG = rs.string(forColumn: "TRIG")
                    items.LDL = rs.string(forColumn: "LDL")
                    items.date = rs.string(forColumn: "date")
                    items.time = rs.string(forColumn: "time")
                    chArray.append(items)
                    totalC.append(Double(items.TC!)!)
                    highDL.append(Double(items.HDL!)!)
                    triglycerides.append(Double(items.TRIG!)!)
                    lowDL.append(Double(items.LDL!)!)
                    print(totalC)
                    print(highDL)
                    print(triglycerides)
                    print(lowDL)
                }
                chps.delegate = self
                chps.dataSource = self
                chps.reloadData()
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
        getAllCHData()
        self.updateGraph()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Function customizes look of plotted data and chart
    func updateGraph() {
            let chData = LineChartData()
            var chTC = [ChartDataEntry]()
            
            for i in 0..<totalC.count {
                chTC.append(ChartDataEntry(x: Double(i), y: Double(totalC[i])))
        }
            
            let TCLine = LineChartDataSet(entries: chTC, label: "TC")
            TCLine.colors = [NSUIColor.init(red: 255.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)]
            TCLine.lineWidth = 3
            TCLine.highlightColor = .red
            TCLine.circleColors = [NSUIColor.init(red: 255.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)]
            
            chData.addDataSet(TCLine)
            
            if (highDL.count > 0) {
                var chHDL = [ChartDataEntry]()
                for i in 0..<highDL.count {
                    chHDL.append(ChartDataEntry(x: Double(i), y: Double(highDL[i]) ))
                }
                let HDLLine = LineChartDataSet(entries: chHDL, label: "HDL")
                HDLLine.colors = [NSUIColor.red]
                HDLLine.lineWidth = 3
                HDLLine.highlightColor = .red
                HDLLine.circleColors = [NSUIColor.red]
                
                chData.addDataSet(HDLLine)
            }
        
        if (triglycerides.count > 0) {
            var chTRIG = [ChartDataEntry]()
            for i in 0..<triglycerides.count {
                chTRIG.append(ChartDataEntry(x: Double(i), y: Double(triglycerides[i]) ))
            }
            let TRIGLine = LineChartDataSet(entries: chTRIG, label: "TRIG")
            TRIGLine.colors = [NSUIColor.red]
            TRIGLine.lineWidth = 3
            TRIGLine.highlightColor = .red
            TRIGLine.circleColors = [NSUIColor.red]
            
            chData.addDataSet(TRIGLine)
        }
        
        if (lowDL.count > 0) {
            var chLDL = [ChartDataEntry]()
            for i in 0..<lowDL.count {
                chLDL.append(ChartDataEntry(x: Double(i), y: Double(lowDL[i]) ))
            }
            let LDLLine = LineChartDataSet(entries: chLDL, label: "LDL")
            LDLLine.colors = [NSUIColor.red]
            LDLLine.lineWidth = 3
            LDLLine.highlightColor = .red
            LDLLine.circleColors = [NSUIColor.red]
            
            chData.addDataSet(LDLLine)
        }
        
            
            // Displays data and customizes the graph
                self.ChChartView.data = chData
            self.ChChartView.rightAxis.enabled = false
            self.ChChartView.xAxis.drawGridLinesEnabled = false
            self.ChChartView.leftAxis.drawGridLinesEnabled = false
            self.ChChartView.rightAxis.drawGridLinesEnabled = false
            self.ChChartView.xAxis.labelPosition = .bottom
    }
}
extension ChChartsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chArray.count
    }
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
           
              let cell = chps.dequeueReusableCell(withIdentifier: "CHCell", for: indexPath) as! CHCell
               //tableView.separatorColor = UIColor.white
        cell.layer.borderColor = UIColor.brown.cgColor
        cell.layer.borderWidth = 4
        //cell.layer.cornerRadius = 10
        cell.clipsToBounds = false
              let obj = chArray[indexPath.row]
               cell.configureCH(dict: obj)
               return cell
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let datach = self.chArray[indexPath.row]
        let cellID = datach.id
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, scrollview, completionHandler) in
            let database = FMDatabase(url: fileUrl)
            guard database.open() else {
                print("Not fetch database")
                return
            }
            do {
                _ =  database.executeUpdate("delete from CTable where id =? ", withArgumentsIn: [cellID!])
            }
            catch let err {
                print(err.localizedDescription)
            }
            database.close()
            
            self.totalC.removeAll()
            self.highDL.removeAll()
            self.triglycerides.removeAll()
            self.lowDL.removeAll()
            self.getCHData()
            self.updateGraph()
            
            completionHandler(true)
        }
        delete.backgroundColor = UIColor.red
        let swipeConfigure = UISwipeActionsConfiguration(actions: [delete])
        swipeConfigure.performsFirstActionWithFullSwipe = false
        return swipeConfigure
    }
}
class CHCell: UITableViewCell {
    @IBOutlet weak var lblTC: UILabel!
    @IBOutlet weak var lblHDL: UILabel!
    @IBOutlet weak var lblTRIG: UILabel!
    @IBOutlet weak var lblLDL: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    func configureCH(dict: CHData){
        lblTC.text = dict.TC
        lblHDL.text = dict.HDL
        lblTRIG.text = dict.TRIG
        lblLDL.text = dict.LDL
        lblDate.text = dict.date
        lblTime.text = dict.time
    }
}
