//
//  PointsViewController.swift
//  Jokester
//
//  Created by Taufiq Husain on 3/10/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import UIKit
import Parse

class PointsViewController: UIViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet weak var points_label: UILabel!
    @IBOutlet weak var ranking_label: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var back_button: UIBarButtonItem!
    @IBAction func back_button(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Status bar
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        view.backgroundColor = UIColor(red:0.25, green:0.62, blue:1.0, alpha:1.0)
        self.view.addSubview(view)
        
        // Design
        imageview.image = UIImage(named: "balloon.png")
        imageview.contentMode = .ScaleAspectFit
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Update total points
        let currentUser = PFUser.currentUser();
        var query = PFQuery(className:"Points");
        query.whereKey("userid", equalTo: currentUser!.objectId!);
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            
            // Total
            var total = 0;
            if error != nil {
                
                // Create an object
                let points = PFObject(className:"Points")
                points["userid"] = currentUser!.objectId!
                points["total"] = 0
                points.saveInBackground()
                total = 0;
                self.points_label.text = String(total);
            }
            else {
                if let object = object {
                    total = object["total"] as! Int
                    self.points_label.text = String(total);
                }
            }
            
            // Ranking
            query = PFQuery(className:"Points");
            query.whereKey("total", greaterThan: total);
            query.countObjectsInBackgroundWithBlock({ (count, error) -> Void in
                var ranking = count + 1
                if(ranking < 10 && ranking != 0) {
                    self.ranking_label.text = String("#\(ranking)");
                }
                else if(ranking >= 10 && ranking < 20) {
                    self.ranking_label.text = "Top 20";
                }
                else if(ranking >= 20 && ranking < 30) {
                    self.ranking_label.text = "Top 30";
                }
                else if(ranking >= 30 && ranking < 40) {
                    self.ranking_label.text = "Top 40";
                }
                else if(ranking >= 40 && ranking < 50) {
                    self.ranking_label.text = "Top 50";
                }
                else if(ranking >= 50 && ranking < 100) {
                    self.ranking_label.text = "Top 100";
                }
                else if(ranking >= 100 && ranking < 1000) {
                    self.ranking_label.text = "Top 1000";
                }
                else {
                    self.ranking_label.text = "Unranked";
                }
            })
            
        }
    }
}
