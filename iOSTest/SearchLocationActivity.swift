import Foundation
import CoreLocation
import UIKit
import MapKit
import Firebase

class SearchLocationActivity: UIViewController {
    var db: Firestore!
    var dayOfWeek = Calendar.current.component(.weekday, from: Date())
    
    let locationManager = CLLocationManager()
  //  let locationGPS = CLLocationManager.g
    var longitudeGPS = 0
    var latitudeGPS = 0
    var isGPSEnabled = false
    var isNetworkEnabled = false
    let MIN_DISTANCE_CHANGE_FOR_UPDATES = 10 // 10 miles
    let MIN_TIME_BW_UPDATES = 1000 * 60 * 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
    }
        
    
    
    func search() {
        self.db.collection("Locations").whereField("serviceBloodSugar", isEqualTo: true).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            
            
            else {
            for document in querySnapshot!.documents {
                var city = document["city"]
                let coords = document.get("location")
                let point = coords as! GeoPoint
                let latitude = point.latitude
                let longitude = point.longitude
                    print(latitude,longitude)
                
                let phone = document.get("phone")
                var services = "No services"
                var bloodPressure = ""
                var bloodSugar = ""
                var cholesterol = ""
                var fluShot = ""
                var pneumonia = ""
                var shingles = ""
                var hepB = ""
                var tetanus = ""
                
                var schedule = document["hoursNormal"]
                
                if (self.dayOfWeek == 7) {
                    schedule = document["hoursSat"]
                    print(schedule!)
                }
                else if (self.dayOfWeek == 1) {
                    schedule = document["hoursSun"]
                    print(schedule!)
                }
                else {
                    schedule = document["hoursNormal"]
                 //   print(schedule!)
                }
                
                let serviceBloodPressure = document.get("serviceBloodPressure")
                let serviceBloodSugar = document.get("serviceBloodSugar")
                let serviceCholesterol = document.get("serviceCholesterol")
                let serviceFlu = document.get("serviceFlu")
                let servicePneumonia = document.get("servicePneumonia")
                let serviceShingles = document.get("serviceShingles")
                let serviceHepB = document.get("serviceHepB")
                let serviceTetanus = document.get("serviceTetanus")
                
                
                
                if (serviceBloodPressure as? Bool  == true && serviceBloodSugar as? Bool == false && serviceCholesterol as? Bool == false && serviceFlu as? Bool == false && servicePneumonia as? Bool == false && serviceShingles as? Bool == false && serviceHepB as? Bool == false && serviceTetanus as? Bool == false) {
                    bloodPressure = "Blood Pressure,"
                }
                
                else if (serviceBloodPressure as? Bool == true && (serviceBloodSugar as? Bool == true || serviceCholesterol as? Bool == true || serviceFlu as? Bool == true || servicePneumonia as? Bool == true || serviceShingles as? Bool == true || serviceHepB as? Bool == true || serviceTetanus as? Bool == true)) {
                    bloodPressure = "Blood Pressure,"
                }
                
                if (serviceBloodSugar as? Bool == true) {
                    bloodSugar = " Blood Sugar,"
                }
                if (serviceCholesterol as? Bool == true) {
                    cholesterol = " Cholesterol,"
                }
                if (serviceFlu as? Bool == true) {
                    fluShot = " Flu Shot,"
                }
                if (serviceShingles as? Bool == true) {
                    shingles = " Shingles,"
                }
                if (serviceHepB as? Bool == true) {
                    hepB = " Hepatitis B,"
                }
                if (serviceTetanus as? Bool == true) {
                    tetanus = " Tetanus"
                }
                
                
                
                var distance = 0.0
                
                let state = document.get("state")
                let streetAddress = document.get("address")
                let url = document.get("website")
                let zip = document.get("zip")
                
          //      if (locationGPS != nul) {
           //         distance =
          //      }
               /* if (serviceBloodPressure == true && serviceBloodSugar == false && serviceCholesterol == false && serviceFlu == false && servicePneumonia == false && serviceShingles == false && serviceHepB == false && serviceTetanus == false) {
                    bloodPressure = "Blood Pressure"
                            } else if (serviceBloodPressure == true && (serviceBloodSugar == true || serviceCholesterol == true || serviceFlu == true || servicePneumonia == true || serviceShingles == true || serviceHepB == true || serviceTetanus == true)) {
                                bloodPressure = "Blood Pressure,"
                            }
                
                
                */
                }
            }
        }
        
    }
}
