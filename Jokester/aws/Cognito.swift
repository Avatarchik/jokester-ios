//
//  Cognito.swift
//  LOL
//
//  Created by Taufiq Husain on 2/10/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import Foundation
import Parse

// Initialize
func cognito_initialize() {
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
        identityPoolId:"us-east-1:ccd7ef83-70d2-44a9-8bc0-07d1c1408ef9")
    let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
    AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
}

// Authorize
func cognito_authorize(app: String) {
    let syncClient = AWSCognito.defaultCognito()
    let dataset = syncClient.openOrCreateDataset(app)
    let currentUser = PFUser.currentUser()
    if currentUser != nil {
        dataset.setString(currentUser!.username!, forKey:"username")
        dataset.synchronize().continueWithBlock {(task: AWSTask!) -> AnyObject! in
            return nil
        }
    }
}