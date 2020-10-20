//
//  BPGraphViewController.swift
//  iOSTest
//
//  Created by Garriss Moseley on 3/18/20.
//  Finished by Anquan Gamble on 10/20/20
//  Copyright © 2020 Garriss Moseley. All rights reserved.
//
//  This file controls the graph functions/design for the
//  blood pressure readings




import Charts
import FMDB

protocol BPDataDelegate {
    func getBPData()
}

class BPChartsViewController: UIViewController, BPDataDelegate {
    @IBOutlet weak var BPChartView: LineChartView!
    @IBOutlet weak var bpps: UITableView!
    var bpArray = [BPData]()
    var bpDelegate: BPDataDelegate?
    var syst: [Double] = []
    var dias: [Double] = []
    var bpX = [BPData]()
        
    
    func getBPData() {
            getAllData()
        }
    
    func getAllData() {
        let myURL = fileUrl
        print(myURL)
        bpArray.removeAll()
        let database = FMDatabase(url: fileUrl)
        if database.open() {
            do {
                let rs = try database.executeQuery("select * from BPTable order by date, time", values: nil)
                while rs.next() {
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
                }
                bpps.delegate = self
                bpps.dataSource = self
                bpps.reloadData()
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
            getAllData()
            self.updateGraph()
            
        }
        
        let sectionColors: [UIColor] = [.systemPink]

       override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    func updateGraph() {
            let bpData = LineChartData()
            var bpSystolic = [ChartDataEntry]()
            
            for i in 0..<syst.count {
                bpSystolic.append(ChartDataEntry(x: Double(i), y: Double(syst[i])))
        }
            
            let sysLine = LineChartDataSet(entries: bpSystolic, label: "Systolic")
            sysLine.colors = [NSUIColor.init(red: 255.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)]
            sysLine.lineWidth = 3
            sysLine.highlightColor = .red
            sysLine.circleColors = [NSUIColor.init(red: 255.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)]
            
            bpData.addDataSet(sysLine)
            
            if (dias.count > 0) {
                var bpDiastolic = [ChartDataEntry]()
                for i in 0..<dias.count {
                    bpDiastolic.append(ChartDataEntry(x: Double(i), y: Double(dias[i]) ))
                }
                let diaLine = LineChartDataSet(entries: bpDiastolic, label: "Diastolic")
                diaLine.colors = [NSUIColor.red]
                diaLine.lineWidth = 3
                diaLine.highlightColor = .red
                diaLine.circleColors = [NSUIColor.red]
                
                bpData.addDataSet(diaLine)
            }
            
            // Displays data and customizes the graph
            self.BPChartView.data = bpData
            self.BPChartView.rightAxis.enabled = false
            self.BPChartView.xAxis.drawGridLinesEnabled = false
            self.BPChartView.leftAxis.drawGridLinesEnabled = false
            self.BPChartView.rightAxis.drawGridLinesEnabled = false
            self.BPChartView.xAxis.labelPosition = .bottom
    }
}
    // Will need invalidate() and notifyDataSetChanged() to notify the graphs
    // that data has been added/deleted and needs to be refreshed
extension BPChartsViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bpArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
           
              let cell = bpps.dequeueReusableCell(withIdentifier: "BPCell", for: indexPath) as! BPCell
               
              let obj = bpArray[indexPath.row]
               cell.configureBP(dict: obj)
               return cell
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let databp = self.bpArray[indexPath.row]
        let cellID = databp.id
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, scrollview, completionHandler) in
            let database = FMDatabase(url: fileUrl)
            guard database.open() else {
                print("Not fetch database")
                return
            }
            do {
                _ =  database.executeUpdate("delete from BPTable where id =? ", withArgumentsIn: [cellID!])
            }
            catch let err {
                print(err.localizedDescription)
            }
            database.close()
            
            self.syst.removeAll()
            self.dias.removeAll()
            self.getBPData()
            self.updateGraph()
            
            completionHandler(true)
        }
        delete.backgroundColor = UIColor.red
        let swipeConfigure = UISwipeActionsConfiguration(actions: [delete])
        swipeConfigure.performsFirstActionWithFullSwipe = false
        return swipeConfigure
    }
}

class BPCell: UITableViewCell {

    @IBOutlet weak var lblSys: UILabel!
    @IBOutlet weak var lblDia: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    func configureBP(dict: BPData) {
        lblSys.text = dict.systolic
        lblDia.text = dict.diastolic
        lblDate.text = dict.date
        lblTime.text = dict.time
    }
}
