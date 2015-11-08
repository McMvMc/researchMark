//
//  MainViewController.swift
//  twitter
//
//  Created by McTavish Wang on 15/10/4.
//  Copyright (c) 2015年 McTavish Wang. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet var tv: UITableView!
    let locationManager = CLLocationManager()
    var city = ""
    var longi:CLLocationDegrees = 0.0
    var lati:CLLocationDegrees = 0.0
    
    var posts:[String:String] = [String:String]()
    
    var ref = Firebase(url: "https://testrealtime.firebaseio.com/")
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns the number of rows in a section
        
        return posts.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //need an outlet
/*    func reload(city:String, longi: CLLocationDegrees, lati: CLLocationDegrees)-> Void{
        let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        //self.tableView(self, cellForRowAtIndexPath: NSIndexPath(index: 0))
    }
*/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // returns the actual cell
        
        println("get cell \(Int(indexPath.row))")
        if(Int(indexPath.row) == 0)
        {
            var cell = UITableViewCell()
            cell.textLabel?.text = "Current Location: city \(city) longi \(longi) lati \(lati)"
            return cell
        }
        
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        var keys: Array = Array(self.posts.keys)
        
        cell.textLabel?.text = posts[keys[indexPath.row]]   as String!
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            self.posts = snapshot.value.objectForKey("Posts") as! [String:String]
            println(self.posts)
            self.tableView.reloadData()
        })
        
/*        var timer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("reload"), userInfo: nil, repeats: true)
*/
        //init the location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //start getting the location
        self.locationManager.startUpdatingLocation()
        println("start updating location")
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        ref.unauth()
        self.performSegueWithIdentifier("logoutSegue", sender: self)
        
    }
    
    
    // location
   
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            println("got location")
            
            if error != nil{
                println("Error: \(error.localizedDescription) ")
                return
            }
            
            if placemarks.count>0{
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
                println("reloading")
                self.tableView(self.tv, cellForRowAtIndexPath: NSIndexPath(index: 0))
                self.tableView.reloadData()
            }
            
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark)
    {
        city = placemark.locality
        longi = locationManager.location.coordinate.longitude
        lati = locationManager.location.coordinate.latitude
        
        self.locationManager.stopUpdatingLocation()
        println(city)
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
        println("\(longi)")
        println("\(lati)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: \(error.localizedDescription)")
    }
    
}
