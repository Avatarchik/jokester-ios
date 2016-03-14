//
//  MainViewController.swift
//  Jokester
//
//  Created by Taufiq Husain on 3/7/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import UIKit
import Parse
import FBAudienceNetwork

class MainViewController: UIViewController, FBInterstitialAdDelegate {
    
    var interstitialAd: FBInterstitialAd?
    var draggableBackground: DraggableViewBackground!;
    
    @IBAction func report_button(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("report_joke", object: nil);
    }
    
    func load_ad() {
        self.interstitialAd = FBInterstitialAd(placementID: "1064117836978248_1064119360311429")
        self.interstitialAd!.delegate = self
        self.interstitialAd!.loadAd();
    }
    
    func interstitialAdDidLoad(interstitialAd: FBInterstitialAd) {
        interstitialAd.showAdFromRootViewController(self)
    }
    
    func interstitialAd(interstitialAd: FBInterstitialAd, didFailWithError error: NSError) {
        print(error);
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet weak var main_view: UIView!
    @IBOutlet weak var pie_button: UIBarButtonItem!
    @IBAction func pie_button(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PointsViewController") as! PointsViewController
        self.presentViewController(vc, animated: false, completion: nil)
    }
    
    @IBOutlet weak var write_button: UIBarButtonItem!
    @IBAction func write_button(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("WriteViewController") as! WriteViewController
        self.presentViewController(vc, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "load_ad", name: "load_ad", object: nil);
        
        // Status bar
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        view.backgroundColor = UIColor(red:0.25, green:0.62, blue:1.0, alpha:1.0)
        self.view.addSubview(view)
        
        // Cards
        self.main_view.backgroundColor = UIColor.clearColor();
        self.draggableBackground = DraggableViewBackground(frame: self.main_view.frame)
        self.main_view.addSubview(draggableBackground)
        
        // Jokes File
        /*
        do {
            if let path = NSBundle.mainBundle().pathForResource("jokes", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
                let lines = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                for line in lines {
                    
                    // Joke
                    let joke = PFObject(className:"Joke")
                    joke["userid"] = "admin"
                    joke["gender"] = ""
                    joke["location"] = ""
                    joke["geopoint"] = PFGeoPoint(latitude: 0, longitude: 0)
                    joke["text"] = line
                    
                    // Age
                    joke["age"] = Int(0)
                    joke["points"] = Int(arc4random_uniform(10)) + 10;
                    
                    // Save
                    joke.saveEventually();
                }
            }
        } catch {}
        */
    }
    
    override func viewDidAppear(animated: Bool) {
        self.draggableBackground.setupData(self.view);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
