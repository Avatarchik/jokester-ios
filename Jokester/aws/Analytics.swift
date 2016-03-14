//
//  Analytics.swift
//  LOL
//
//  Created by Taufiq Husain on 2/10/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import Foundation
import Parse

/* Globals */
var analytics: AWSMobileAnalytics?
var eventClient: AWSMobileAnalyticsEventClient?

// Initialize
func analytics_initialize() {
    analytics = AWSMobileAnalytics(forAppId: "77236e31e0d149299897c9cb7e07b959", identityPoolId: "us-east-1:ccd7ef83-70d2-44a9-8bc0-07d1c1408ef9");
    eventClient = analytics!.eventClient;
}

// Record
func analytics_record_event(action: String, interface: String, custom: [String:String] = [String:String]()) {
    let currentUser = PFUser.currentUser();
    if(currentUser != nil) {
        let customEvent = eventClient!.createEventWithEventType(action);
        customEvent.addAttribute(interface, forKey: "Interface");
        
        // ID
        if(currentUser!.objectId != nil) {
            customEvent.addAttribute(currentUser!.objectId, forKey: "objectId");
        }
        
        // Birthyear
        let birthyear = currentUser!["birthyear"] as? String;
        if(birthyear != nil) {
            let components: NSDateComponents = NSCalendar.currentCalendar().components(.Year, fromDate: NSDate())
            let age = components.year - Int(birthyear as String!)!;
            customEvent.addAttribute(String(age), forKey: "Age");
        }
        
        // Gender
        if(currentUser!["gender"] != nil) {
            customEvent.addAttribute(currentUser!["gender"] as! String, forKey: "Gender");
        }
        
        // Other values
        for (key, value) in custom {
            customEvent.addAttribute(value, forKey: key);
        }
        
        // Done
        eventClient!.recordEvent(customEvent)
        eventClient!.submitEvents();
    }
}
