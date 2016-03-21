//
//  AgeViewController.swift
//  Jokester
//
//  Created by Taufiq Husain on 3/7/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import UIKit
import Parse

class AgeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var agePickerDataSource = [String]();
    var agePickerDataValue = [String]();
    var age = "";
    @IBOutlet weak var age_picker: UIPickerView!
    
    @IBOutlet weak var age_button: UIButton!
    @IBAction func age_button(sender: AnyObject) {
        if(self.age_picker.hidden == true) {
            self.age = "18";
            self.age_button.setTitle(self.age, forState: UIControlState.Normal)
            self.age_picker.hidden = false;
        }
        else {
            self.age_picker.hidden = true;
        }
    }

    @IBOutlet weak var next_button: UIButton!
    @IBAction func next_button(sender: AnyObject) {
        
        if(self.age.characters.count <= 0) {
            let alertController = UIAlertController(title: "Age Required", message:
                "Please select your age to proceed.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            
            let components: NSDateComponents = NSCalendar.currentCalendar().components(.Year, fromDate: NSDate())
            let birthyear = components.year - Int(self.age)!
            
            // Save
            let currentUser = PFUser.currentUser();
            currentUser!["birthyear"] = String(birthyear);
            currentUser?.saveEventually();
            
            // Next
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("GenderViewController") as! GenderViewController
            self.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initialization
        self.age_picker.dataSource = self;
        self.age_picker.delegate = self;
        
        // Design
        next_button.backgroundColor = UIColor.clearColor()
        next_button.layer.cornerRadius = 3
        next_button.layer.borderWidth = 2
        next_button.layer.borderColor = UIColor.whiteColor().CGColor
        age_button.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
        age_button.layer.cornerRadius = 3
        age_button.layer.borderWidth = 2
        age_button.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Setup
        for (var i = 18; i < 150; i++) {
            agePickerDataSource.append(String(i))
            agePickerDataValue.append(String(i))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Closes the picker
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
        age_picker.hidden = true;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return agePickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return agePickerDataSource[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.age = agePickerDataValue[row];
        self.age_button.setTitle(self.age, forState: UIControlState.Normal)
    }
}
