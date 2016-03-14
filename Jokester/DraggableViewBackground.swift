//
//  DraggableViewBackground.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit
import Parse

class DraggableViewBackground: UIView, DraggableViewDelegate {
    var allCards: [DraggableView]!
    let MAX_BUFFER_SIZE = 2
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var CARD_HEIGHT: CGFloat = 0
    var CARD_WIDTH: CGFloat = 0
    var FULL_HEIGHT: CGFloat = 0
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var likeButton: UIButton!
    var dislikeButton: UIButton!
    var activityIndicator = UIActivityIndicatorView()
    var total_swiped_cards = 0
    
    struct Joke {
        var objectId: String
        var userid: String
        var text: String
        var location: String
    }
    var jokes = [Joke]();
    var top_jokes = [Joke]();
    var todays_jokes = [Joke]();
    var nearby_jokes = [Joke]();
    var age_jokes = [Joke]();
    var gender_jokes = [Joke]();
    var joke_showing = [String:Bool]();
    
    func report_joke() {
        UIApplication.sharedApplication().openURL(NSURL(string: "mailto:getjokester@gmail.com?subject=Report%20about%20joke:%20'\((loadedCards[0].objectId) as String)'")!)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        
        // Set up
        super.init(frame: frame)
        super.layoutSubviews()
        
        // Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "report_joke", name: "report_joke", object: nil);
    }
    
    func setupData(view: UIView) -> Void {
        
        // Clear out data first
        self.joke_showing.removeAll();
        self.jokes.removeAll();
        self.top_jokes.removeAll();
        self.todays_jokes.removeAll();
        self.nearby_jokes.removeAll();
        self.age_jokes.removeAll();
        self.gender_jokes.removeAll();
        
        // Top Jokes
        self.activityIndicator = show_activity_indicator(view);
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let currentUser = PFUser.currentUser();
        var query = PFQuery(className: "Joke");
        query.whereKey("userid", notEqualTo: currentUser!.objectId!)
        query.whereKey("likers", notEqualTo: currentUser!.objectId!)
        query.whereKey("dislikers", notEqualTo: currentUser!.objectId!)
        query.limit = 400;
        query.orderByDescending("points");
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if(self.joke_showing[object.objectId!] == nil || self.joke_showing[object.objectId!] == false) {
                        self.joke_showing[object.objectId!] = true;
                        self.top_jokes.append(Joke(objectId: object.objectId!, userid: object["userid"] as! String, text: object["text"] as! String, location: object["location"] as! String));
                    }
                }
                
                // Today's Jokes
                let yesterday = NSDate().dateByAddingTimeInterval(-60*60*24);
                query = PFQuery(className: "Joke");
                query.whereKey("userid", notEqualTo: currentUser!.objectId!)
                query.whereKey("likers", notEqualTo: currentUser!.objectId!)
                query.whereKey("dislikers", notEqualTo: currentUser!.objectId!)
                query.whereKey("createdAt", greaterThan: yesterday);
                query.limit = 100;
                query.orderByDescending("points");
                query.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        for object in objects! {
                            if(self.joke_showing[object.objectId!] == nil || self.joke_showing[object.objectId!] == false) {
                                self.joke_showing[object.objectId!] = true;
                                self.todays_jokes.append(Joke(objectId: object.objectId!, userid: object["userid"] as! String, text: object["text"] as! String, location: object["location"] as! String));
                            }
                        }
                        
                        // Nearby Jokes
                        query = PFQuery(className: "Joke");
                        query.whereKey("userid", notEqualTo: currentUser!.objectId!)
                        query.whereKey("likers", notEqualTo: currentUser!.objectId!)
                        query.whereKey("dislikers", notEqualTo: currentUser!.objectId!)
                        query.whereKey("geopoint", nearGeoPoint: currentUser!["geopoint"] as! PFGeoPoint, withinMiles: 50.00)
                        query.limit = 100;
                        query.orderByDescending("points");
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            if error == nil {
                                for object in objects! {
                                    if(self.joke_showing[object.objectId!] == nil || self.joke_showing[object.objectId!] == false) {
                                        self.joke_showing[object.objectId!] = true;
                                        self.todays_jokes.append(Joke(objectId: object.objectId!, userid: object["userid"] as! String, text: object["text"] as! String, location: object["location"] as! String));
                                    }
                                }
                                
                                // Combine all jokes
                                var top_count = 0;
                                var todays_count = 0;
                                var nearby_count = 0;
                                while(self.jokes.count < (self.top_jokes.count + self.todays_jokes.count + self.nearby_jokes.count - 3)) {
                                    if((top_count + 3) < self.top_jokes.count) {
                                        self.jokes.append(self.top_jokes[top_count])
                                        top_count++;
                                        self.jokes.append(self.top_jokes[top_count])
                                        top_count++;
                                        self.jokes.append(self.top_jokes[top_count])
                                        top_count++;
                                    }
                                    if(todays_count < self.todays_jokes.count) {
                                        self.jokes.append(self.todays_jokes[todays_count])
                                        todays_count++;
                                    }
                                    if(nearby_count < self.nearby_jokes.count) {
                                        self.jokes.append(self.nearby_jokes[nearby_count])
                                        nearby_count++;
                                    }
                                }
                                hide_activity_indicator(self.activityIndicator);
                                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                                self.setupView();
                                self.allCards = []
                                self.loadedCards = []
                                self.cardsLoadedIndex = 0
                                self.loadCards()
                            }
                        }
                    }
                }
            }
        }
    }

    func setupView() -> Void {
        if(likeButton != nil) {
            likeButton.removeFromSuperview();
        }
        if(dislikeButton != nil) {
            dislikeButton.removeFromSuperview();
        }
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height - self.frame.origin.y
        self.CARD_WIDTH = screenWidth - 50;
        self.CARD_HEIGHT = screenWidth - 50;
        self.FULL_HEIGHT = screenWidth + 35;
        self.backgroundColor = UIColor.clearColor();
        dislikeButton = UIButton(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2 + 25, self.screenHeight/2 - self.FULL_HEIGHT/2 - self.frame.origin.y + self.CARD_HEIGHT + 25, 60, 60))
        dislikeButton.setBackgroundImage(UIImage(named: "dislikeButtonActive"), forState: UIControlState.Normal)
        dislikeButton.userInteractionEnabled = true
        dislikeButton.addTarget(self, action: "swipeLeft", forControlEvents: UIControlEvents.TouchUpInside)
        likeButton = UIButton(frame: CGRectMake(self.frame.size.width/2 + CARD_WIDTH/2 - 85, self.screenHeight/2 - self.FULL_HEIGHT/2 - self.frame.origin.y + self.CARD_HEIGHT + 25, 60, 60))
        likeButton.setBackgroundImage(UIImage(named: "likeButtonActive"), forState: UIControlState.Normal)
        likeButton.userInteractionEnabled = true
        likeButton.addTarget(self, action: "swipeRight", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(dislikeButton)
        self.addSubview(likeButton)
    }

    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2, self.screenHeight/2 - self.FULL_HEIGHT/2 - self.frame.origin.y, CARD_WIDTH, CARD_HEIGHT))
        draggableView.joke.text = self.jokes[index].text
        draggableView.location.text = "";
        if(self.jokes[index].location.characters.count > 0) {
            draggableView.location.text = "☉ \(self.jokes[index].location)"
        }
        draggableView.objectId = self.jokes[index].objectId
        draggableView.userid = self.jokes[index].userid
        draggableView.delegate = self
        return draggableView
    }

    func loadCards() -> Void {
        
        // Clear out the previous cards
        for subUIView in self.subviews as [UIView] {
            if(subUIView.tag == 95762) {
                subUIView.removeFromSuperview()
            }
        }
        
        if self.jokes.count > 0 {
            let numLoadedCardsCap = self.jokes.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : self.jokes.count
            for var i = 0; i < self.jokes.count; i++ {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                newCard.tag = 95762;
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            // Add new cards
            for var i = 0; i < loadedCards.count; i++ {
                loadedCards[i].tag = 95762;
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }
    
    func show_ad() {
        if(total_swiped_cards % 5 == 0) {
            NSNotificationCenter.defaultCenter().postNotificationName("load_ad", object: nil);
        }
    }

    func cardSwipedLeft(card: UIView) -> Void {
        
        // Disliker
        self.total_swiped_cards++;
        let currentUser = PFUser.currentUser();
        var query = PFQuery(className:"Joke")
        query.getObjectInBackgroundWithId(loadedCards[0].objectId) {
            (joke: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let joke = joke {
                joke.incrementKey("points", byAmount: -1);
                joke.addUniqueObject(currentUser!.objectId!, forKey: "dislikers");
                joke.saveInBackground();
            }
        }
        
        // Points
        query = PFQuery(className:"Points");
        query.whereKey("userid", equalTo: loadedCards[0].userid);
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                
                // Create an object
                let points = PFObject(className:"Points")
                points["userid"] = self.loadedCards[0].userid
                points["total"] = -1
                points.saveInBackground()
            }
            else {
                if let object = object {
                    object.incrementKey("points", byAmount: -1);
                    object.saveInBackground()
                }
            }
        }
        
        // Remove
        loadedCards.removeAtIndex(0)
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
        
        // Show Ad
        show_ad();
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        
        // Liker
        self.total_swiped_cards++;
        let currentUser = PFUser.currentUser();
        var query = PFQuery(className:"Joke")
        query.getObjectInBackgroundWithId(loadedCards[0].objectId) {
            (joke: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let joke = joke {
                joke.incrementKey("points", byAmount: 1);
                joke.addUniqueObject(currentUser!.objectId!, forKey: "likers");
                joke.saveInBackground();
            }
        }
        
        // Points
        query = PFQuery(className:"Points");
        query.whereKey("userid", equalTo: loadedCards[0].userid);
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                
                // Create an object
                let points = PFObject(className:"Points")
                points["userid"] = self.loadedCards[0].userid
                points["total"] = 1
                points.saveInBackground()
            }
            else {
                if let object = object {
                    object.incrementKey("points", byAmount: 1);
                    object.saveInBackground()
                }
            }
        }
        
        // Remove
        loadedCards.removeAtIndex(0)
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
        
        // Show Ad
        show_ad();
    }

    func swipeRight() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.rightClickAction()
    }

    func swipeLeft() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.leftClickAction()
    }
    
}