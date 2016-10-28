//
//  sendMessageViewController.swift
//  collaboration
//
//  Created by nick on 1/9/16.
//  Copyright © 2016 Supreme Leader. All rights reserved.
//

import UIKit

class sendMessageViewController: UIViewController{
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var emailSubject: UITextField!
    @IBOutlet weak var messageInput: UITextView!
    
    @IBAction func sendButton(sender: UIButton) {
        if emailSubject.text! as String == "" || messageInput.text! as String == "" || emailSubject.text! as String == "Message subject" || messageInput.text! as String == "Write your message here. If you are reporting a bug, please be as detailed as possible." {
            self.sendAlert("Error", message: "Invalid input")
            return
        }
        let myUrl = NSURL(string: "http://nickpitoniak.com/gone/supportEmail.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "message=\(messageInput.text! as String)&subject=\(emailSubject.text! as String)&secretKey=kjdfb4u7bksSDDF44wlksdnw33j4"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                if let responseData = data {
                    let responseString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                    if error != nil {
                        print("Error: \(error)")
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        print(responseString)
                        if responseString != "success" {
                            self.sendAlert("Error", message: "Email was unable to be sent")
                            return
                        }
                        self.sendAlert("Success", message: "Your email has been sent")
                    } // end of main dispatch
                } // check if responseData returned
            } // first dispatch
        } // NSURLSession instantiation
        task.resume()
    }
    
    func sendAlert(subject: String, message: String) {
        let alertController = UIAlertController(title: subject, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        messageInput.layer.borderWidth = 0.5
        messageInput.layer.borderColor = borderColor.CGColor
        messageInput.layer.cornerRadius = 5.0
    }
}
