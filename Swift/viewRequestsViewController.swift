
import UIKit

class viewRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var requests: NSMutableArray! = NSMutableArray()
    
    let MyCryptoMachine = CryptoMachine()
    let MyFuctionMachine = FunctionMachine()
    
    func tableView(tableView: UITableView, numberOfRowsInSection Section: Int) -> Int {
        return self.requests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! requestsCell
        cell.cellLabel?.text = self.requests.objectAtIndex(indexPath.row) as? String
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: "addFriend:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        if Reachability.isConnectedToNetwork() != true {
            self.sendAlert("Error", message: "You must be connected to the internet to use this application")
            return
        }
        
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let encUsername = MyCryptoMachine.encryptStringToBase64(username)
        
        if username == "" {
            self.sendAlert("Error", message: "Unable to retreive friend request")
            return
        }
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/viewRequests.php")
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
                        let NSResponseString = responseString! as NSString
                        let firstThree = NSResponseString.substringWithRange(NSRange(location: 0, length: 3))
                        if responseString !== "" && firstThree == "gfg" {
                            let minusVerificationArray = responseString!.componentsSeparatedByString("gfg")
                            if minusVerificationArray.count < 1 {
                                self.sendAlert("Error", message: "Unable to get incoming requests one")
                                return
                            }
                            if minusVerificationArray[1] == "" {
                                self.sendAlert("No incoming friend requests", message: "")
                                return
                            }
                            let requestors = minusVerificationArray[1].componentsSeparatedByString("9254203598")
                            for requestor in requestors {
                                self.requests.addObject(self.MyCryptoMachine.decryptBase64ToString(requestor))
                                self.tableView.reloadData()
                            }
                        } // end check for gfg return
                    } // end main dispatch
                } // end check for return data
            } // end first dispatch
        } // end NSURLSession instantiation
        task.resume()
    }
    
    func sendAlert(subject: String, message: String) {
            let alertController = UIAlertController(title: subject, message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addFriend(sender: UIButton) {
        if Reachability.isConnectedToNetwork() != true {
            self.sendAlert("Error", message: "You must be connected to the internet to use this app")
            return
        }
        
        let requestIndex = sender.tag
        let requestor = self.requests.objectAtIndex(requestIndex) as! String
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        
        let encUsername = MyCryptoMachine.encryptStringToBase64(username)
        let encRequestor = MyCryptoMachine.encryptStringToBase64(requestor)
        
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/acceptRequest.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        print("ENCRYPTED USERNAME: \(encUsername)")
        print("ENCRYPTED REUESTOR \(encRequestor)")
        print("DECRYPTED USERNAME: \(MyCryptoMachine.decryptBase64ToString(encUsername))")
        print("DECRYPTED REUESTOR \(MyCryptoMachine.decryptBase64ToString(encRequestor))")
        let postString = "username=\(encUsername)&requestor=\(encRequestor)&secretKey=kjdfb4u7bksSDDF44wlksdnw33j4"
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
                        print("Response string: \(responseString)")
                        if responseString == "" {
                            self.sendAlert("Error", message: "Unable to add friend")
                            return
                        }
                        if responseString != "success" {
                            self.sendAlert("Error", message: "An error was encountered")
                            return
                        }
                        self.sendAlert("Success", message: "\(requestor) is now your friend")
                        self.tableView.reloadData()
                    } // end main dispatch
                } // end data return check
            } // end first dispatch
        } // end NSURLSession instantiation
        task.resume()
        self.requests.removeObjectAtIndex(sender.tag)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() != true {
            self.sendAlert("Error", message: "You must be connected to the internet to use this app")
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
