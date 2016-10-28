
import UIKit

class addFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var friendInput: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let MyFunctionMachine = FunctionMachine()
    let MyCryptoMachine = CryptoMachine()

    var didReturnResults = true
    var textArray: NSMutableArray = NSMutableArray()
    
    @IBAction func searchButton(sender: UIButton) {
        if Reachability.isConnectedToNetwork() != true {
            self.sendAlert("Error", message: "You must be connected to the internet to use this application")
            return
        }
        textArray = NSMutableArray()
        loadTable(friendInput.text!.lowercaseString)
        self.tableView.reloadData()
    }
    
    func loadTable(possibleUsername: String) {
        let searchUsername = self.MyCryptoMachine.encryptStringToBase64(possibleUsername)
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let encUsername = self.MyCryptoMachine.encryptStringToBase64(username)
        
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/searchForFriend.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "username=\(encUsername)&possibleUsername=\(searchUsername)&secretKey=kjdfb4u7bksSDDF44wlksdnw33j4"
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
                    let NSResponseString = responseString! as NSString
                    if NSResponseString == "gfg" {
                        let searchUsernameDec = self.MyCryptoMachine.decryptBase64ToString(searchUsername)
                        if searchUsernameDec == username {
                            self.sendAlert("You cannot be friends with yourself", message: "")
                            return
                        }
                        self.sendAlert("User \(searchUsernameDec) does not exist or has already been added", message: "")
                        return
                    }
                    let firstThree = NSResponseString.substringWithRange(NSRange(location: 0, length: 3))
                    if firstThree == "gfg" {
                        if responseString == "gfgfriend" {
                            self.sendAlert("Error", message: "This user is already your friend")
                            return
                        }
                        let minusVerificationArray = responseString!.componentsSeparatedByString("gfg")
                        if minusVerificationArray.count < 1 || minusVerificationArray[1] == "" {
                            let searchUsernameDec = self.MyCryptoMachine.decryptBase64ToString(searchUsername)
                            if searchUsernameDec == username {
                                self.sendAlert("You cannot be friends with yourself", message: "")
                                return
                            }
                            self.sendAlert("User '\(searchUsernameDec)' does not exist", message: "")
                            return
                        }
                        let theString = minusVerificationArray[1]
                        if theString.rangeOfString("9254203598") != nil {
                            self.sendAlert("Error", message: "Unable to search for friend")
                            return
                        }
                        let friendsToAdd = theString.componentsSeparatedByString("9254203598")
                        for friend in friendsToAdd {
                            self.textArray.addObject(self.MyCryptoMachine.decryptBase64ToString(friend))
                            self.tableView.reloadData()
                        }
                    } // check that responseString == "gfg"
                } // end main dispatch
                } // check that data has been successfully returned
            } // end first dispatch
        } // end NSURLSession instantiation
        task.resume()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection Section: Int) -> Int {
        return self.textArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! addFriendTableViewCell
        cell.usernameLabel?.text = self.textArray.objectAtIndex(indexPath.row) as? String
        cell.addFriendButton.tag = indexPath.row
        cell.addFriendButton.addTarget(self, action: "addFriend:", forControlEvents: .TouchUpInside)
        return cell
    }

    func addFriend(sender: UIButton) {
        if Reachability.isConnectedToNetwork() != true {
            self.sendAlert("Error", message: "You must be connected to the internet to use this application")
            return
        }
        
        let requestIndex = sender.tag
        let requestee = self.textArray.objectAtIndex(requestIndex) as! String
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let encUsername = MyCryptoMachine.encryptStringToBase64(username)
        let encRequestee = MyCryptoMachine.encryptStringToBase64(requestee)
        
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/sendRequest.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "username=\(encUsername)&requestee=\(encRequestee)&secretKey=kjdfb4u7bksSDDF44wlksdnw33j4"
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
                    if responseString as! String != "success" {
                        self.sendAlert("Error", message: "Your request was unable to be sent")
                    }
                } // end main dispatch
                } // check that data has been successfuly returned
            } // end first dispatch
        } // end NSURLSession instantiation
        task.resume()
        textArray.removeObjectAtIndex(requestIndex)
        self.tableView.reloadData()
    }
    
    func dismissKeyboard() {
        self.friendInput.resignFirstResponder()
    }
    
    func sendAlert(subject: String, message: String) {
            let alertController = UIAlertController(title: subject, message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() != true {
            self.sendAlert("Error", message: "You must be connected to the internet to use this application")
        }
        // keyboard instatiation
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
