//
//  ViewController.swift
//  Jokester
//
//  Created by Taufiq Husain on 2/25/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var notice_textview: UITextView!
    @IBOutlet weak var login_button: UIButton!
    @IBAction func login_button(sender: AnyObject) {
        PFAnonymousUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil || user == nil {
                print("Error: Login Failed!")
            } else {
                
                // Start
                user!["app"] = "jokester";
                user!.saveInBackground();
                
                // Create a Points
                let points = PFObject(className:"Points")
                points["userid"] = user!.objectId
                points["total"] = 0
                points.saveInBackground()
                
                // Next
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
        
        // Notice
        self.notice_textview.delegate = self;
        let attributedString = NSMutableAttributedString(string: "By tapping start, you agree to the Terms of Service and Privacy Policy of Jokester.")
        attributedString.addAttribute(NSLinkAttributeName, value: "http://getjokester.com/terms/", range: NSMakeRange(35, 16))
        attributedString.addAttribute(NSLinkAttributeName, value: "http://getjokester.com/privacy/", range: NSMakeRange(56, 14))
        self.notice_textview.attributedText = attributedString
        self.notice_textview.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        self.notice_textview.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        self.notice_textview.textColor = UIColor.whiteColor()
        self.notice_textview.textAlignment = .Center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        UIApplication.sharedApplication().openURL(URL)
        return true
    }

}

