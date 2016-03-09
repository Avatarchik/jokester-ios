//
//  ViewController.swift
//  Jokester
//
//  Created by Taufiq Husain on 2/25/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var login_button: UIButton!
    @IBAction func login_button(sender: AnyObject) {
        PFAnonymousUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil || user == nil {
                print("Error: Login Failed!")
            } else {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AgeViewController") as! AgeViewController
                self.presentViewController(vc, animated: false, completion: nil)
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Design
        login_button.backgroundColor = UIColor.clearColor()
        login_button.layer.cornerRadius = 3
        login_button.layer.borderWidth = 2
        login_button.layer.borderColor = UIColor.whiteColor().CGColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

