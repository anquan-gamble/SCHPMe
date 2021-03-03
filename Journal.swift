//
//  ViewController.swift
//  iOSTest
//
//  Created by Aaron Fulmer on 1/17/20.
//  Copyright © 2020 Aaron Fulmer. All rights reserved.
//

import UIKit

class Journal: UIViewController {

    /*
    @IBAction func unwind(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }*/
    
    @IBAction func gohome(_ sender: Any) {
        
        performSegue(withIdentifier: "goHome", sender: self)
    }
    
    // Swipes to 1st Page of Journal
    @IBAction func backPage1(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Swipes to 2nd Page of Journal
    @IBAction func backPage2(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
}

