//
//  GenderViewController.swift
//  Jokester
//
//  Created by Taufiq Husain on 3/7/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import UIKit
import Parse

class GenderViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var genderPickerDataSource = ["Male", "Female"];
    var genderPickerDataValue = ["Male", "Female"];
    var gender = "";
    @IBOutlet weak var gender_picker: UIPickerView!
    @IBOutlet weak var gender_button: UIButton!
    @IBAction func gender_button(sender: AnyObject) {
        if(self.gender_picker.hidden == true) {
            self.gender = "Male";
            self.gender_button.setTitle(self.gender, forState: UIControlState.Normal)
            self.gender_picker.hidden = false;
        }
        else {
            self.gender_picker.hidden = true;
        }
    }
    
    @IBOutlet weak var next_button: UIButton!
    @IBAction func next_button(sender: AnyObject) {
        if(self.gender.characters.count <= 0) {
            let alertController = UIAlertController(title: "Gender Required", message:
                "Please select your self-identified gender to proceed.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            
            // Save
            let currentUser = PFUser.currentUser();
            currentUser!["gender"] = self.gender;
            currentUser?.saveEventually();
        
            // Next
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LocationViewController") as! LocationViewController
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
        self.gender_picker.dataSource = self;
        self.gender_picker.delegate = self;
        
        // Design
        next_button.backgroundColor = UIColor.clearColor()
        next_button.layer.cornerRadius = 3
        next_button.layer.borderWidth = 2
        next_button.layer.borderColor = UIColor.whiteColor().CGColor
        gender_button.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
        gender_button.layer.cornerRadius = 3
        gender_button.layer.borderWidth = 2
        gender_button.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Closes the picker
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
        gender_picker.hidden = true;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPickerDataSource[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.gender = genderPickerDataValue[row];
        self.gender_button.setTitle(self.gender, forState: UIControlState.Normal)
    }

}