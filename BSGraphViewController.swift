//
//  BSGraphViewController.swift
//  iOSTest
//
//  Created by Garriss Moseley on 4/24/20.
//  Copyright © 2020 Garriss Moseley. All rights reserved.
//
//  This file controls the graph functions/design for the blood sugar readings
//  Temporary values are hardcoded here to test the functionality of the graph

import UIKit
import Charts
import FMDB

protocol BSDataDelegate {
    func getBSData()
}

class BSChartsViewController: UIViewController, BSDataDelegate {

    @IBOutlet weak var BSChartView: LineChartView!
    @IBOutlet weak var bsps: UITableView!
    var bsArray = [BSData]()
    var bsDelegate: BSDataDelegate?
    var bloodSL: [Double] = []
    var bsX = [BSData]()
    let cellSpacingHeight: CGFloat = 5
    func getBSData() {
        getAllBSData()
    }
    
    func getAllBSData() {
        let myURL = fileUrl
        print(myURL)
        bsArray.removeAll()
        let database = FMDatabase(url: fileUrl)
        if database.open() {
            do {
                let rs = try database.executeQuery("select * from BloodSTable11 order by date, time", values: nil)
                while rs.next() {
                    let items : BSData = BSData()
                    items.id = rs.string(forColumn: "id")
                    items.bloodSugarLevel = rs.string(forColumn: "bloodSugarLevel")
                    items.fast = rs.string(forColumn: "fast")

                    items.date = rs.string(forColumn: "date")
                    items.time = rs.string(forColumn: "time")
                    bsArray.append(items)
                    bloodSL.append(Double(items.bloodSugarLevel!)!)
                    //dias.append(Double(items.diastolic!)!)
                    print(bloodSL)
                  //  print(dias)
                }
                bsps.delegate = self
                bsps.dataSource = self
                bsps.reloadData()
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
        getAllBSData()
        self.updateGraph()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func updateGraph() {
            let bsData = LineChartData()
            var bsBSL = [ChartDataEntry]()
            
            for i in 0..<bloodSL.count {
                bsBSL.append(ChartDataEntry(x: Double(i), y: Double(bloodSL[i])))
        }
            
            let bslLine = LineChartDataSet(entries: bsBSL, label: "Blood Sugar")
            bslLine.colors = [NSUIColor.init(red: 128.0/255.0, green: 0/255.0, blue: 128.0/255.0, alpha: 1.0)]
            bslLine.lineWidth = 3
            bslLine.highlightColor = .red
            bslLine.circleColors = [NSUIColor.init(red: 128.0/255.0, green: 0/255.0, blue: 128.0/255.0, alpha: 1.0)]
            
            bsData.addDataSet(bslLine)
            
            
            
            // Displays data and customizes the graph
            self.BSChartView.data = bsData
            self.BSChartView.rightAxis.enabled = false
            self.BSChartView.xAxis.drawGridLinesEnabled = false
            self.BSChartView.leftAxis.drawGridLinesEnabled = false
            self.BSChartView.rightAxis.drawGridLinesEnabled = false
            self.BSChartView.xAxis.labelPosition = .bottom
    }
}
extension BSChartsViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bsArray.count
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
           
              let cell = bsps.dequeueReusableCell(withIdentifier: "BSCell", for: indexPath) as! BSCell
               tableView.separatorColor = UIColor.white
              let obj = bsArray[indexPath.row]
               cell.configureBS(dict: obj)
               return cell
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let databs = self.bsArray[indexPath.row]
        let cellID = databs.id
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, scrollview, completionHandler) in
            let database = FMDatabase(url: fileUrl)
            
            guard database.open() else {
                print("Not fetch database")
                return
            }
            do {
                _ =  database.executeUpdate("delete from BloodSTable11 where id =? ", withArgumentsIn: [cellID!])
            }
            catch let err {
                print(err.localizedDescription)
            }
            database.close()
            
            self.bloodSL.removeAll()
            //self.dias.removeAll()
            self.getBSData()
            self.updateGraph()
            
            completionHandler(true)
        }
        delete.backgroundColor = UIColor.red
        let swipeConfigure = UISwipeActionsConfiguration(actions: [delete])
        swipeConfigure.performsFirstActionWithFullSwipe = false
        return swipeConfigure
    }
}
class BSCell: UITableViewCell {

    @IBOutlet weak var lblBSL: UILabel!
    @IBOutlet weak var lblfast: UILabel!
    //@IBOutlet weak var lblnonfast: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    func configureBS(dict: BSData) {
        lblBSL.text = dict.bloodSugarLevel
        lblfast.text = dict.fast
        //lblnonfast.text = dict.nonfast
        lblDate.text = dict.date
        lblTime.text = dict.time
    }
 
}
