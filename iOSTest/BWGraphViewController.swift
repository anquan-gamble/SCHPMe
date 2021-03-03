//
//  BWGraphViewController.swift
//  iOSTest
//
//  Created by Garriss Moseley on 4/24/20.
//  Copyright © 2020 Garriss Moseley. All rights reserved.
//
// This file controls the graph functions/design for the body weight readings
// Temporary values are hardcoded here to test the functionality of the graph

import Foundation
import UIKit
import Charts
import SQLite3
import FMDB

protocol BWDataDelegate {
    func getBWData()
}

class BWChartsViewController: UIViewController, BWDataDelegate {
    @IBOutlet weak var BWChartView: LineChartView!
    @IBOutlet weak var bwps: UITableView!
    
    var bwArray = [BWData]()
    var bwDelegate: BWDataDelegate?
    var weigh: [Double] = []
    var bwX = [BWData]()
    let cellSpacingHeight: CGFloat = 5
    
    func getBWData() {
        getAllData()
    }
    
    func getAllData() {
        let myURL = fileUrl
        print(myURL)
        bwArray.removeAll()
        let database = FMDatabase(url: fileUrl)
        if database.open() {
            do {
                let rs = try database.executeQuery("select * from BWTable", values: nil)
                while rs.next() {
                    let items : BWData = BWData()
                    items.id = rs.string(forColumn: "id")
                    items.weight = rs.string(forColumn: "weight")
                    items.date = rs.string(forColumn: "date")
                    items.time = rs.string(forColumn: "time")
                    bwArray.append(items)
                    
                    weigh.append(Double(items.weight!)!)
                    print(weigh)
                }
                bwps.delegate = self
                bwps.dataSource = self
                bwps.reloadData()
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
     
     override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
     }
     
     // Function customizes look of plotted data and chart
    
    func updateGraph() {
            
            let bwData = LineChartData()
            var BWeight = [ChartDataEntry]()
            
            
            for i in 0..<weigh.count {
                BWeight.append(ChartDataEntry(x: Double(i), y: Double(weigh[i])))
        }
            
            let bwLine = LineChartDataSet(entries: BWeight, label: "Weight")
            bwLine.colors = [NSUIColor.init(red: 255.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)]
            bwLine.lineWidth = 3
            bwLine.highlightColor = .orange
            bwLine.circleColors = [NSUIColor.init(red: 255.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)]
            
            bwData.addDataSet(bwLine)
            
            // Displays data and customizes the graph
            self.BWChartView.data = bwData
            self.BWChartView.rightAxis.enabled = false
            self.BWChartView.xAxis.drawGridLinesEnabled = false
            self.BWChartView.leftAxis.drawGridLinesEnabled = false
            self.BWChartView.rightAxis.drawGridLinesEnabled = false
            self.BWChartView.xAxis.labelPosition = .bottom
     }
}
     
extension BWChartsViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bwArray.count
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
           
              let cell = bwps.dequeueReusableCell(withIdentifier: "BWCell", for: indexPath) as! BWCell
               cell.layer.borderColor = UIColor.white.cgColor
               cell.layer.borderWidth = 2
               
               cell.clipsToBounds = false
              let obj = bwArray[indexPath.row]
               cell.configureBW(dict: obj)
               return cell
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let databw = self.bwArray[indexPath.row]
        let cellID = databw.id
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, scrollview, completionHandler) in
            let database = FMDatabase(url: fileUrl)
            guard database.open() else {
                print("Not fetch database")
                return
            }
            do {
                _ =  database.executeUpdate("delete from BWTable where id =? ", withArgumentsIn: [cellID!])
            }
            catch let err {
                print(err.localizedDescription)
            }
            database.close()
            
            self.weigh.removeAll()
            self.getBWData()
            
            completionHandler(true)
        }
        delete.backgroundColor = UIColor.red
        let swipeConfigure = UISwipeActionsConfiguration(actions: [delete])
        swipeConfigure.performsFirstActionWithFullSwipe = false
        return swipeConfigure
    }
}
class BWCell: UITableViewCell {

    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    func configureBW(dict: BWData) {
        lblWeight.text = dict.weight
        lblDate.text = dict.date
        lblTime.text = dict.time
    }
}
