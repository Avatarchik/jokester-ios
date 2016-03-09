//
//  LocationViewController.swift
//  Jokester
//
//  Created by Taufiq Husain on 3/7/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import UIKit
import Parse
import MapKit

class LocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var location = "";
    let locationManager = CLLocationManager();
    var geopoint = PFGeoPoint(latitude:0, longitude:0);
    @IBOutlet weak var location_button: UIButton!
    @IBAction func location_button(sender: AnyObject) {
        locationManager.delegate = self;
        locationManager.desiredAccuracy - kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
    }
    
    @IBOutlet weak var next_button: UIButton!
    @IBAction func next_button(sender: AnyObject) {
        if(self.location.characters.count <= 0) {
            let alertController = UIAlertController(title: "You're Invisible", message:
                "We couldn't find your location at the moment but don't worry about it.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                self.presentViewController(vc, animated: false, completion: nil)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else {
            
            // Save
            let currentUser = PFUser.currentUser();
            currentUser!["location"] = self.location;
            currentUser!["geopoint"] = self.geopoint;
            currentUser?.saveEventually();
            
            // Next
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
            self.presentViewController(vc, animated: false, completion: nil)
        }
        locationManager.stopUpdatingLocation();
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Design
        next_button.backgroundColor = UIColor.clearColor()
        next_button.layer.cornerRadius = 3
        next_button.layer.borderWidth = 2
        next_button.layer.borderColor = UIColor.whiteColor().CGColor
        location_button.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
        location_button.layer.cornerRadius = 3
        location_button.layer.borderWidth = 2
        location_button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Close the keyboard when user touches outside of the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    // Update the location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userlocation:CLLocation = locations[0];
        geopoint = PFGeoPoint(latitude: userlocation.coordinate.latitude, longitude: userlocation.coordinate.longitude);
        CLGeocoder().reverseGeocodeLocation(userlocation, completionHandler: {(placemarks, error) -> Void in
            if placemarks == nil {
                if error != nil {
                    print("Reverse geocoder failed with error: " + error!.localizedDescription);
                    return
                }
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark;
                if(pm.locality != nil && pm.country != nil && pm.administrativeArea != nil) {
                    if(pm.country == "United States" || pm.country == "Canada")
                    {
                        self.location = pm.locality! + ", " + pm.administrativeArea!
                        self.location_button.setTitle(self.location, forState: UIControlState.Normal)
                    }
                    else
                    {
                        self.location = pm.locality! + ", " + pm.country!
                        self.location_button.setTitle(self.location, forState: UIControlState.Normal)
                    }
                }
            }
            else {
                print("Error with receiving geolocation data!");
                return
            }
        })
    }

}
