//
//  AddTableViewController.swift
//  
//
//  Created by McTavish Wang on 15/10/20.
//
//

import UIKit
import CoreLocation

class AddTableViewController: UITableViewController, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var ref = Firebase(url: "https://testrealtime.firebaseio.com/")
    
    @IBOutlet weak var postTextField: UITextField!
    
    @IBAction func done(sender: AnyObject) {
        if postTextField.text == "" {
            return
        }
        
        ref.childByAppendingPath("Posts").childByAutoId().setValue(postTextField.text)
        ref.childByAppendingPath("users/\(ref.authData.uid)/post").childByAutoId().setValue(postTextField.text)
    self.performSegueWithIdentifier("finishAddingMessage", sender: self)
        
    }
    
    func reload(){
    
        if postTextField.text == ""{
            doneButton.enabled = false
        }else if postTextField.text != ""{
            doneButton.enabled = true
        }
        
    }
    

    override func viewDidLoad(){
        super.viewDidLoad()
        
        var timer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("reload"), userInfo: nil, repeats: true)
        
        doneButton.enabled = false
        
        //init the location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //start getting the location
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
        
            if error != nil{
                println("Error: \(error.localizedDescription) ")
                return
            }
            
            if placemarks.count>0{
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
            
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark)
    {
        var city = placemark.locality
        var longi = locationManager.location.coordinate.longitude
        var lati = locationManager.location.coordinate.latitude
        
        self.locationManager.stopUpdatingLocation()
        println(placemark.locality)
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
        println("\(locationManager.location.coordinate.longitude)")
        println("\(locationManager.location.coordinate.latitude)")
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: \(error.localizedDescription)")
    }
    
    
    
    
}
