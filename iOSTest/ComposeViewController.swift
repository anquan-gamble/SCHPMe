//
//  ComposeViewController.swift
//  iOSTest
//
//  Created by FMU on 2/27/20.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import UIKit
import Firebase

class ComposeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var db: Firestore!
    
    
    private var locations = [Location]()
    private var locationCollectionRef: CollectionReference!
    @IBOutlet private weak var locationTable: UITableView!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
  
        locationCollectionRef = Firestore.firestore().collection("Locations")
        db = Firestore.firestore()
        sampleTest()
    }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print("Location setup \(locatID.count)")
    return locations.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cell = locationTable.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
    
    let obj = locations[indexPath.row]
    cell.configureLC(location: obj)
    return cell
    /*
    if let cell = locationTable.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell {
        cell.configureLC(location: locations[indexPath.row])
        return cell
    } else {
        return UITableViewCell()
    } */
       /*let cell = locationTable.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
       let location = locatID[indexPath.row]
       
       cell.clinicName.text = location
       return cell */
   }
    
    func onComplete() {
        
        
    }
    
    func sampleTest() {
        
    //    Firestore.firestore().collection(
        locationCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    let nameOfClinic = data["clinicName"] as? String ?? "Unknown"
                    let addressOfClinic = data["address"] as? String ?? "No Address"
                    
                   // let distanceOfClinic = if
                    let phoneOfClinic = data["phone"] as? String ?? " "
                    
                    let scheduleClinic =  data["hoursNormal"] as? String ?? ""
                    let distanceClinic = 0
                    let servicesClinic = data["servic"] as? String ?? " "
                    let urlClinic = data["website"] as? String ?? " "
                    
                    let latitudeClinic = data["location"] as? Double ?? 0
                    let longitudeClinic = data["location"] as? Double ?? 0
                    
                    
                    let newLocation = Location(locationName: nameOfClinic, searchAddress: addressOfClinic, searchDistance: Double(distanceClinic), searchPhone: phoneOfClinic, searchSchedule: scheduleClinic, searchServices: servicesClinic, searchURL: urlClinic, searchLatitude: latitudeClinic, searchLongitude: longitudeClinic)
                    self.locations.append(newLocation)
                  //  print(self.locations[0])
                }
            }
        }
    }
    @IBOutlet weak var radBPB: UIButton!
    @IBOutlet weak var radBSB: UIButton!
    @IBOutlet weak var radCHB: UIButton!
    @IBOutlet weak var radFSB: UIButton!
    @IBOutlet weak var radShinB: UIButton!
    @IBOutlet weak var radPneuB: UIButton!
    @IBOutlet weak var radHepBB: UIButton!
    @IBOutlet weak var radTetB: UIButton!
    
    @IBOutlet weak var bloodPressure: UILabel!
    @IBOutlet weak var bloodSugar: UILabel!
    @IBOutlet weak var cholesterol: UILabel!
    @IBOutlet weak var fluShot: UILabel!
    @IBOutlet weak var shingles: UILabel!
    @IBOutlet weak var pneumonia: UILabel!
    @IBOutlet weak var hepatitusB: UILabel!
    @IBOutlet weak var tetanus: UILabel!
    
    
    var BPflag = false
    var BSflag = false
    var CHflag = false
    var FSflag = false
    var SHINGLESflag = false
    var PNEUMONIAflag = false
    var HepBflag = false
    var TETANUSflag = false
    
    let checkedImage1 = UIImage(named: "ic_blood_pressure_checked")
    let uncheckedImage1 = UIImage(named: "ic_blood_pressure")
    let checkedImage2 = UIImage(named: "ic_blood_sugar_selected")
    let uncheckedImage2 = UIImage(named:"ic_blood_sugar")
    let checkedImage3 = UIImage(named: "ic_cholesterol_icon_selected")
    let uncheckedImage3 = UIImage(named:"ic_cholesterol_icon")
    let checkedImage4 = UIImage(named: "ic_vaccinations_selected")
    let uncheckedImage4 = UIImage(named:"ic_vaccinations")
    
    @IBAction func gohome(_ sender: Any) {
        
        performSegue(withIdentifier: "goHomeBsEntry", sender: self)
    }
    @IBAction func BloodPressureChecked(_ sender: Any) {
        if (BPflag == false) {
            radBPB.setImage(checkedImage1, for: UIControl.State.normal)
            BPflag = true
            
            db.collection("Locations").whereField("city", isEqualTo: "Kingstree").getDocuments() {
                
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        
                        let data = document.data()
                        print("\(document.documentID) => \(data)")
                        
                      //  print("\(data)")
                    }
                    
                }
            }
        }
        else {
            radBPB.setImage(uncheckedImage1, for: UIControl.State.normal)
            BPflag = false
        }
    }
    @IBAction func BloodSugarChecked(_ sender: Any) {
        if (BSflag == false) {
            radBSB.setImage(checkedImage2, for: UIControl.State.normal)
            BSflag = true
            
            db.collection("Locations").whereField("serviceBloodSugar", isEqualTo: true).getDocuments() {
                
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
        }
        else {
            radBSB.setImage(uncheckedImage2, for: UIControl.State.normal)
            BSflag = false
        }
    }
    @IBAction func CholesterolChecked(_ sender: Any) {
        if (CHflag == false) {
            radCHB.setImage(checkedImage3, for: UIControl.State.normal)
            CHflag = true
            
            db.collection("Locations").whereField("serviceCholesterol", isEqualTo: true).getDocuments() {
                
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
        }
        else {
            radCHB.setImage(uncheckedImage3, for: UIControl.State.normal)
            CHflag = false
        }
    }
    @IBAction func FluShotChecked(_ sender: Any) {
        if (FSflag == false) {
            radFSB.setImage(checkedImage4, for: UIControl.State.normal)
            FSflag = true
            db.collection("Locations").whereField("serviceFlu", isEqualTo: true).getDocuments() {
                
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
        }
        else {
            radFSB.setImage(uncheckedImage4, for: UIControl.State.normal)
            FSflag = false
        }
    }
    @IBAction func ShinglesChecked(_ sender: Any) {
        if (SHINGLESflag == false) {
            radShinB.setImage(checkedImage4, for: UIControl.State.normal)
            SHINGLESflag = true
            
            db.collection("Locations").whereField("serviceShingles", isEqualTo: true).getDocuments() {
                
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
        }
        else {
            radShinB.setImage(uncheckedImage4, for: UIControl.State.normal)
            SHINGLESflag = false
        }
    }
    @IBAction func PneumoniaChecked(_ sender: Any) {
        if (PNEUMONIAflag == false) {
            radPneuB.setImage(checkedImage4, for: UIControl.State.normal)
            PNEUMONIAflag = true
            
            db.collection("Locations").whereField("servicePneumonia", isEqualTo: true).getDocuments() {
                
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
        }
        else {
            radPneuB.setImage(uncheckedImage4, for: UIControl.State.normal)
            PNEUMONIAflag = false
        }
    }
    @IBAction func HepatitusBChecked(_ sender: Any) {
        if (HepBflag == false) {
            radHepBB.setImage(checkedImage4, for: UIControl.State.normal)
            HepBflag = true
            
            db.collection("Locations").whereField("serviceHepB", isEqualTo: true).getDocuments() {
                
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
        }
        else {
            radHepBB.setImage(uncheckedImage4, for: UIControl.State.normal)
            HepBflag = false
        }
    }
    @IBAction func TetanusChecked(_ sender: Any) {
        if (TETANUSflag == false) {
            radTetB.setImage(checkedImage4, for: UIControl.State.normal)
            TETANUSflag = true
            
            db.collection("Locations").whereField("serviceTetanus", isEqualTo: true).getDocuments() {
                
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
        }
        else {
            radTetB.setImage(uncheckedImage4, for: UIControl.State.normal)
            TETANUSflag = false
        }
    }
    @IBAction func SearchClicked(_ sender: Any) {
        db.collection("Locations").whereField("city", isEqualTo: "Kingstree").getDocuments() {
            
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    let data = document.data()

                    print("\(document.documentID) => \(data)")
                }
                
            }
        }
        //searchResults()
        
    }
    func searchResults() {

        db.collection("Locations").getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for documents in querySnapshot!.documents {
                    self.locatID.append(documents.documentID)
                }
            }
            print(self.locatID)
            //self.locationTable.reloadData()
        }
    }
    var locatID = [String]()
   // private var db = Firestore.firestore()
  /*  func fetchData() {
        db.collection("locations").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            documents.map {
                (queryDocumentSnaposhot) -> Location in
                
                let
            }
        }
        
        db.collection("Locations").order(by: "location")
        .getDocuments()
        .a
    } */
    
    
    
    
    /*var ref:DatabaseReference?
    
    var databaseHandle:DatabaseHandle?
 //   @IBOutlet weak var tableView: UITableView!
    var postData = [String]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        cell?.textLabel?.text = postData[indexPath.row]
        
        return cell!
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //    tableView.delegate = self
     //   tableView.dataSource = self
            
            // Set the firebase reference
            ref = Database.database().reference()
        
            
        
        
        
            // Retrieve the posts and listen for changes
        databaseHandle  = ref!.child("Locations").observe(.value, with: { (snapshot) in
                
                // Code to execute when a child is added under "Locations"
                // Take the value from the snapshot and added it to the postData array
                
                // Try to convert the value of the data to a string
                //let post = snapshot.value as? NSDictionary
            
            let data = snapshot.value as? [String:NSDictionary]
            
            for (key, value) in data!{
                //print("\(key)AND\(value)")
                for (key, value2) in value{
                    
                    print("Key: \(key)")
                    print("\tValue: \(value2)\n")
                    let c = "\(key) = \(value2)"
                    // Append the data to our postData array
                    self.postData += [c]
                    
                    
                    
                    
                    
                }
                
            }
            // Reload the tableView
       //     self.tableView.reloadData()
            })
            
        }
        
        
        
        // Do any additional setup after loading the view.
    
    
func addPost(_ sender: Any) {
    }
    
func cancelPost(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

*/

}
class LocationCell: UITableViewCell {
    
    @IBOutlet weak var clinicName: UILabel!
    @IBOutlet weak var clinicDistance: UILabel!
    @IBOutlet weak var clinicHours: UILabel!
    @IBOutlet weak var clinicServices: UILabel!
    @IBOutlet weak var clinicAddress: UILabel!
    @IBOutlet weak var clinicWebsite: UILabel!
    @IBOutlet weak var clinicPhone: UILabel!
    
    
    func configureLC(location: Location) {
        clinicName.text = location.name
        clinicServices.text = location.services
        //clinicDistance.text = location.distance
        clinicHours.text = location.schedule
    }
}
