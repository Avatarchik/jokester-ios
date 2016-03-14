//
//  WriteViewController.swift
//  Jokester
//
//  Created by Taufiq Husain on 3/10/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import UIKit
import Parse
import MapKit

class WriteViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextViewDelegate {
    
    var location = "";
    let locationManager = CLLocationManager();
    var geopoint = PFGeoPoint(latitude:0, longitude:0);
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textarea: UITextView!
    @IBOutlet weak var location_button: UIButton!
    @IBAction func location_button(sender: AnyObject) {
        locationManager.delegate = self;
        locationManager.desiredAccuracy - kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet weak var back_button: UIBarButtonItem!
    @IBAction func back_button(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil);
    }
    
    // Post a joke
    func post() {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents();
        let currentUser = PFUser.currentUser()
        if(self.textarea.text.characters.count <= 0) {
            UIApplication.sharedApplication().endIgnoringInteractionEvents();
            let alertController = UIAlertController(title: "Text Missing", message:
                "Please enter an actual joke...", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            
            // Joke
            let joke = PFObject(className:"Joke")
            joke["userid"] = currentUser!.objectId!
            joke["gender"] = currentUser!["gender"] as! String
            joke["location"] = self.location
            joke["geopoint"] = self.geopoint
            joke["text"] = self.textarea.text
            joke["points"] = Int(1)
            
            // Age
            let birthyear = currentUser!["birthyear"] as? String
            if(birthyear != nil) {
                let components: NSDateComponents = NSCalendar.currentCalendar().components(.Year, fromDate: NSDate())
                let age = components.year - Int(birthyear as String!)!
                joke["age"] = age
            }
            
            // Save
            joke.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.dismissViewControllerAnimated(false, completion: nil);
                } else {
                    print("Error")
                }
                UIApplication.sharedApplication().endIgnoringInteractionEvents();
            }
        }
    }
    
    @IBOutlet weak var post_button: UIBarButtonItem!
    @IBAction func post_button(sender: AnyObject) {
        post();
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Status bar
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        view.backgroundColor = UIColor(red:0.25, green:0.62, blue:1.0, alpha:1.0)
        self.view.addSubview(view)
        
        // Keyboard
        self.textarea.delegate = self;
        self.textarea.becomeFirstResponder();
        self.textarea.autocorrectionType = .Yes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Show keyboard and move elements
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        self.bottomConstraint.constant = keyboardHeight;
    }
    
    // Close the keyboard when user touches outside of the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    // Pressing "Go" or "Done" should try to post
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            post();
            return false
        }
        else if(textView.text.characters.count >= 250) {
            return false;
        }
        return true
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
                        self.location_button.setTitle("☉ \(self.location)", forState: UIControlState.Normal)
                    }
                    else
                    {
                        self.location = pm.locality! + ", " + pm.country!
                        self.location_button.setTitle("☉ \(self.location)", forState: UIControlState.Normal)
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
