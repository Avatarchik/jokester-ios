//
//  DynamoDB.swift
//  LOL
//
//  Created by Taufiq Husain on 2/15/16.
//  Copyright © 2016 Polar Hills. All rights reserved.
//

import Foundation

// Insert a row
func dynamodb_insert_row(object: AWSDynamoDBObjectModel) {
    let mapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
    let task = mapper.save(object);
    AWSTask(forCompletionOfAllTasks: [task] as [AWSTask]) .continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
        if ((task.error) != nil) {
            print("Error: \(task.error)")
        }
        else {
            print("Success: \(task.description)");
        }
        return nil;
    });
}

// Delete a row
func dynamodb_delete_row(object: AWSDynamoDBObjectModel) {
    let mapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
    let task = mapper.remove(object);
    AWSTask(forCompletionOfAllTasks: [task] as [AWSTask]) .continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
        if ((task.error) != nil) {
            print("Error: \(task.error)")
        }
        else {
            print("Success: \(task.description)");
        }
        return nil;
    });
}

// Get a row (by ID)
func dynamodb_get_row(id: String, myclass: AnyClass) -> AnyObject? {
    let mapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
    let task = mapper.load(myclass, hashKey: id, rangeKey: nil)
    AWSTask(forCompletionOfAllTasks: [task] as [AWSTask]) .continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
        if (task.error != nil) {
            print("Error: \(task.error)");
            return nil;
        }
        else {
            return task.result;
        }
    });
    return nil;
}

// Query for rows (by conditions)
func dynamodb_get_rows(myclass: AnyClass, filters: String, attributes: [NSObject: AnyObject], limit: Int) -> [AnyObject]? {
    let mapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
    let expression = AWSDynamoDBScanExpression()
    expression.limit = limit
    expression.filterExpression = filters
    expression.expressionAttributeValues = attributes
    mapper.scan(myclass, expression: expression).continueWithBlock({(task: AWSTask) -> AnyObject in
        if (task.error != nil) {
            print("Error: \(task.error)");
            return []
        }
        else if (task.exception != nil) {
            print("Error: \(task.exception)");
            return []
        }
        else {
            return task.result!.items as! [AnyObject];
        }
    })
    return [];
}
