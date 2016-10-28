//
//  openingViewController.swift
//  collaboration
//
//  Created by nick on 2/6/16.
//  Copyright © 2016 Supreme Leader. All rights reserved.
//

import UIKit

class openingViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    func sendAlert(subject: String, message: String) {
        let alertController = UIAlertController(title: subject, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        if Reachability.isConnectedToNetwork() == false {
            self.sendAlert("Error", message: "You must be connected to the internet to use this application")
            return
        }
        let theSecretKey = "kjdfb4u7bksSDDF44wlksdnw33j4"
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/importantNews.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                if let responseData = data {
                    let responseString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                    if error != nil {
                        print("Error: \(error)")
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        let theString = responseString as! String
                        let splitArray = theString.componentsSeparatedByString("203598")
                        if splitArray.count > 1 {
                            if theString != "" {
                                self.messageLabel.text = splitArray[1]
                            }
                        } else {
                            self.performSegueWithIdentifier("fromOpenToLogin", sender: nil)
                        }
                    }
                } // end return data check
            } // end first dispatch
        } // end NSURLSession instantiation
        task.resume()
    }
    
}
