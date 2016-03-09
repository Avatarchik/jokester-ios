//
//  S3.swift
//  LOL
//
//  Created by Taufiq Husain on 2/10/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import Foundation

// Upload file
func s3_upload_file(fileurl: NSURL, filename: String, bucketname: String) -> Bool {
    let uploadRequest = AWSS3TransferManagerUploadRequest()
    uploadRequest.body = fileurl
    uploadRequest.key = filename
    uploadRequest.bucket = bucketname
    let transferManager = AWSS3TransferManager.defaultS3TransferManager()
    transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
        if let error = task.error {
            if error.domain == AWSS3TransferManagerErrorDomain as String {
                if let errorCode = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch (errorCode) {
                    case .Cancelled, .Paused:
                        print("upload() canceled")
                        return false;
                    default:
                        print("upload() failed: [\(error)]")
                        return false;
                    }
                } else {
                    print("upload() failed: [\(error)]")
                    return false;
                }
            } else {
                print("upload() failed: [\(error)]")
                return false;
            }
        }
        
        if let exception = task.exception {
            print("upload() failed: [\(exception)]")
            return false;
        }
        return true;
    }
    return false;
}

// Get file
func s3_get_file(filename: String, bucketname: String) -> String {
    return "http://\(bucketname).s3.amazonaws.com/\(filename)";
}
