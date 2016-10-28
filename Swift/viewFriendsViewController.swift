//
//  viewFriendsViewController.swift
//  collaboration
//
//  Created by nick on 11/12/15.
//  Copyright © 2015 Supreme Leader. All rights reserved.
//

import UIKit

class viewFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let MyCryptoMachine = CryptoMachine()
    
    var alertController: UIAlertController!
    
    var initialFriendCount: Int!
    
    var tableIncr = 0
    
    var outputedFriends: [String] = []
    
    var textArray: NSMutableArray! = NSMutableArray()
    
    func tableView(tableView: UITableView, numberOfRowsInSection Section: Int) -> Int {
        return self.textArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("--------------------------------")
        print("TABLE INCR: \(tableIncr)")
        print("TEXT ARRAY LENGTH: \(textArray.count)")
        self.tableIncr++
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! viewFriendsTableCell
        let friendIndex = self.textArray.objectAtIndex(indexPath.row) as? String
        var doesExist = false
        for currentFriendIndex in self.outputedFriends {
            if friendIndex == currentFriendIndex {
                doesExist = true
            }
        }
        if doesExist == true {
            
        }

        
        let friendArray = friendIndex!.componentsSeparatedByString("34875629922")
        for uu in friendArray {
            print("INDEX: \n\(uu)")
        }
        let friendSplit = friendArray[0]
        let friendBlock = friendArray[1]
        print("->\(friendBlock)")
        if friendBlock == "vacant" {
            cell.blockButton.addTarget(self, action: "blockIt:", forControlEvents: .TouchUpInside)
            cell.blockButton.setTitle("Block User", forState: UIControlState.Normal)
        } else {
            cell.blockButton.addTarget(self, action: "unblockIt:", forControlEvents: .TouchUpInside)
            cell.blockButton.setTitle("Unblock User", forState: UIControlState.Normal)
        }
        cell.friendLabel.text = self.MyCryptoMachine.decryptBase64ToString(friendSplit)
        cell.blockButton.tag = indexPath.row
        self.outputedFriends.append(friendIndex!)
        return cell
    }
    
    func sendLoading() {
        self.alertController = UIAlertController(title: "Loading...", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func blockIt(sender: UIButton) {
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let encUsername = MyCryptoMachine.encryptStringToBase64(username)
        let friendJibberish = self.textArray[sender.tag]
        let friendArray = friendJibberish.componentsSeparatedByString("34875629922")
        let friendToBlock = friendArray[0]
        let secretKeyTwo = "kjdfb4u7bksSDDF44wlksdnw33j4"
        let myUrlTwo = NSURL(string: "http://www.nickpitoniak.com/gone/setBlock.php")
        let requestTwo = NSMutableURLRequest(URL: myUrlTwo!)
        requestTwo.HTTPMethod = "POST"
        let encFriendChosen = self.MyCryptoMachine.encryptStringToBase64(friendToBlock)
        print("999\(encFriendChosen)")
        let postStringTwo = "secretKey=\(secretKeyTwo)&username=\(encUsername)&friendToBlock=\(friendToBlock)"
        requestTwo.HTTPBody = postStringTwo.dataUsingEncoding(NSUTF8StringEncoding)
        let taskTwo = NSURLSession.sharedSession().dataTaskWithRequest(requestTwo) {
            data, response, error in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                if let responseData = data {
                    let responseString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                    if error != nil {
                        print("Error: \(error)")
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        print(responseString)
                        if responseString as! String == "success" {
                            self.refresh()
                            self.sendAlert("Success", message: "User blocked")
                        }
                        self.refresh()
                    }
                } // end data return check
            } // end first dispatch
        } // end NSURLSession instantiation
        taskTwo.resume()
    }
    
    func unblockIt(sender: UIButton) {
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let encUsername = MyCryptoMachine.encryptStringToBase64(username)
        let friendJibberish = self.textArray[sender.tag]
        let friendArray = friendJibberish.componentsSeparatedByString("34875629922")
        let friendToBlock = friendArray[0]
        let secretKeyTwo = "kjdfb4u7bksSDDF44wlksdnw33j4"
        let myUrlTwo = NSURL(string: "http://www.nickpitoniak.com/gone/removeBlock.php")
        let requestTwo = NSMutableURLRequest(URL: myUrlTwo!)
        requestTwo.HTTPMethod = "POST"
        let encFriendChosen = self.MyCryptoMachine.encryptStringToBase64(friendToBlock)
        print("999\(encFriendChosen)")
        let postStringTwo = "secretKey=\(secretKeyTwo)&username=\(encUsername)&friendToBlock=\(friendToBlock)"
        requestTwo.HTTPBody = postStringTwo.dataUsingEncoding(NSUTF8StringEncoding)
        let taskTwo = NSURLSession.sharedSession().dataTaskWithRequest(requestTwo) {
            data, response, error in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                if let responseData = data {
                    let responseString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                    if error != nil {
                        print("Error: \(error)")
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        print("RS: \(responseString)")
                        if responseString as! String == "success" {
                            self.refresh()
                            self.sendAlert("Success", message: "User unblocked")
                        }
                        self.refresh()
                    }
                } // end data return check
            } // end first dispatch
        } // end NSURLSession instantiation
        taskTwo.resume()
    }
    
    func refresh() {
        print("UPDATED")
        self.textArray = []
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let encUsername = MyCryptoMachine.encryptStringToBase64(username)
        if username == "" {
            self.textArray.addObject("Error")
            self.textArray.addObject("You are not logged in")
            return
        }
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/getFriends.php")
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
                        print("RSS: \(responseString)")
                        let NSResponseString = responseString! as NSString
                        let firstThree = NSResponseString.substringWithRange(NSRange(location: 0, length: 3))
                        print("FT: \(firstThree)")
                        if responseString == "" || firstThree != "gfg" {
                            self.sendAlert("Error", message: "Unable to get friends")
                            return
                        }
                        self.textArray = []
                        let minusVerificationArray = responseString!.componentsSeparatedByString("gfg")
                        let friends = minusVerificationArray[1].componentsSeparatedByString("9254203598")
                        print("----------------------------")
                        if friends.count > 0 {
                            for friend in friends {
                                print(friend)
                                let friendArrayy = friend.componentsSeparatedByString("34875629922")
                                if friend == "" {
                                    continue
                                }
                                self.textArray.addObject(friend)
                                self.tableIncr = 0
                                self.tableView.reloadData()
                            }
                        }
                    } // end main dispatch
                } else {
                    self.alertController.dismissViewControllerAnimated(true, completion: nil)
                }// check that data has been received
            } // end first dispatch
        } // end NSURLSession instantiation
        task.resume()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refresh()
    }
    
    func sendAlert(subject: String, message: String) {
        let alertController = UIAlertController(title: subject, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
