//
//  choosePartnerViewController.swift
//  collaboration
//
//  Created by nick on 11/24/15.
//  Copyright © 2015 Supreme Leader. All rights reserved.
//

import UIKit

class choosePartnerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let MyCryptoMachine = CryptoMachine()
    let MyFunctionMachine = FunctionMachine()
    
    var alertController: UIAlertController!
    var friends: NSMutableArray = NSMutableArray()
    var friendChosen:String!
    var isConnectedToInternet: Bool!
    
    func tableView(tableView: UITableView, numberOfRowsInSection Section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! choosePartnerCellTableViewCell
        cell.friendLabel?.text = self.friends.objectAtIndex(indexPath.row) as? String
        cell.chooseButton.tag = indexPath.row
        cell.chooseButton.addTarget(self, action: "chooseFriend:", forControlEvents: .TouchUpInside)
        tableView.estimatedRowHeight = requiredHeight(self.friends.objectAtIndex(indexPath.row) as! String)
        tableView.rowHeight = UITableViewAutomaticDimension
        return cell
    }
    
    func requiredHeight(text:String) -> CGFloat {
        let font = UIFont(name: "Helvetica", size: 16.0)
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, 200, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func chooseFriend(sender: UIButton) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func sendLoading() {
        self.alertController = UIAlertController(title: "Loading...", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        if Reachability.isConnectedToNetwork() != true {
            self.sendAlert("Error", message: "You must be connected to the internet to use this app")
            return
        }
        
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username") as String!
        let encUsername = self.MyCryptoMachine.encryptStringToBase64(username)
        
        if username != nil && username != "" {
            let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/getFriendsSimple.php")
            let request = NSMutableURLRequest(URL: myUrl!)
            request.HTTPMethod = "POST"
            let postString = "username=\(encUsername)&secretKey=kjdfb4u7bksSDDF44wlksdnw33j4"
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
                        self.alertController.dismissViewControllerAnimated(true, completion: nil)
                        let NSResponseString = responseString! as NSString
                        let firstThree = NSResponseString.substringWithRange(NSRange(location: 0, length: 3))
                        if responseString == "" || firstThree != "gfg" {
                            self.sendAlert("Error", message: "No friends to message")
                            return
                        }
                            let minusVerificationArray = responseString!.componentsSeparatedByString("gfg")
                            let friends = minusVerificationArray[1].componentsSeparatedByString("9254203598")
                            for friend in friends {
                                if friend != "" {
                                    self.friends.addObject(self.MyCryptoMachine.decryptBase64ToString(friend))
                                    self.tableView.reloadData()
                                }
                            }
                        } // end main dispatch
                    } // return data check
                } // end first dispatch
            } // end NSURLSession instantiation
            task.resume()
            self.sendLoading()
        }
    }

    func sendAlert(subject: String, message: String) {
            let alertController = UIAlertController(title: subject, message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender senderObj: AnyObject?) {
        if(segue.identifier == "toChat") {
            let sender = senderObj as! UIButton
            let requestIndex = sender.tag
            print("Friend chosen:\(self.friends.objectAtIndex(requestIndex))")
            let theVC: chatViewController = segue.destinationViewController as! chatViewController
            theVC.friendChosen = self.friends.objectAtIndex(requestIndex) as! String
        }
    }
    
}
