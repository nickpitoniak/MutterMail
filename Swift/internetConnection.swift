//
//  internetConnection.swift
//  collaboration
//
//  Created by nick on 1/16/16.
//  Copyright © 2016 Supreme Leader. All rights reserved.
//

import Foundation

class ConnectionMachine {
    var isSuccess = false;
    func isConnectedToInternet() -> Bool {
        do {
            let myUrl = NSURL(string: "http://www.nickpitoniak.com/testConnection.html")
            let request = NSMutableURLRequest(URL: myUrl!)
            request.HTTPMethod = "POST"
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    if error != nil {
                        print("Error: \(error)")
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        if responseString as! String == "success" {
                            self.isSuccess = true
                        }
                    }
                }
            }
            task.resume()
            return true
        } catch {
            return false;
        }
    }
}