
import UIKit

class messagesViewController: UIViewController {
    
    @IBAction func viewSettingsButton(sender: UIButton) {
        
    }
    @IBOutlet weak var tableView: UITableView!
    
    var hasBeenWarnedOfVoid = false
    var didSendNoFriendAlert = false
    var firstTimeThrough = true
    var firstTimeThroughTwo = true
    var timer = NSTimer()
    var alertController: UIAlertController!
    var alreadyAddedFriends: [String] = []
    var isConnectedToInternet: Bool!
    var chatsPending: NSMutableArray! = NSMutableArray()
    var hasBeenWarnedOfInternetConnection:Bool = false
    
    let MyCryptoMachine = CryptoMachine()
    let MyFunctionMachine = FunctionMachine()

    func tableView(tableView: UITableView, numberOfRowsInSection Section: Int) -> Int {
        return self.chatsPending.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! messagesCellTableViewCell
        cell.convoMateLabel?.text = self.MyCryptoMachine.decryptBase64ToString((self.chatsPending.objectAtIndex(indexPath.row) as? String)!)
        cell.chatButton.addTarget(self, action: "enterChat:", forControlEvents: .TouchUpInside)
        cell.chatButton.tag = indexPath.row
        return cell
    }
    
    func sendAlert(subject: String, message: String) {
        let alertController = UIAlertController(title: subject, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func refreshButton(sender: UIButton) {
        refreshTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLoad()
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "usernameToMessageWith")
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("refreshTable"), userInfo: nil, repeats: true)
    }
    
    func sendLoading() {
        self.alertController = UIAlertController(title: "Loading...", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func firstLoad() {
        self.sendLoading()
        let secretKeyString = "kjdfb4u7bksSDDF44wlksdnw33j4"
        let savedUsername = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/getMessages.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let encUsername = self.MyCryptoMachine.encryptStringToBase64(savedUsername)
        print("ENC USERNAME: '\(encUsername)'")
        print("secretKeyString: '\(secretKeyString)'")
        let postString = "username=\(encUsername)&secretKey=\(secretKeyString)"
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
                        self.firstTimeThrough = false
                        let NSResponseString = responseString! as NSString
                        let firstThree = NSResponseString.substringWithRange(NSRange(location: 0, length: 3))
                        if responseString !== "" && firstThree == "gfg" {
                            self.hasBeenWarnedOfInternetConnection = false
                            let notGFGArray = responseString!.componentsSeparatedByString("gfg")
                            if notGFGArray[1] != "" {
                                let messageSenders = notGFGArray[1].componentsSeparatedByString("9254203598")
                                print("SENDER COUNT: \(messageSenders.count)")
                                for sender in messageSenders {
                                    if sender == "" {
                                        continue
                                    }
                                    print("SENDER: \(sender)")
                                    var doesAlreadyExist = false
                                    for senderTwo in self.alreadyAddedFriends {
                                        if sender == senderTwo {
                                            doesAlreadyExist = true
                                        }
                                    }
                                    if doesAlreadyExist == false {
                                        //let decSender = self.MyCryptoMachine.decryptBase64ToString(sender)
                                        self.chatsPending.addObject(sender)
                                        self.alreadyAddedFriends.append(sender)
                                        self.tableView.reloadData()
                                    }
                                }
                            } else {
                                
                            }
                        } else {
                            
                        }
                    }
                } else {
                    if self.hasBeenWarnedOfInternetConnection != true {
                        self.sendAlert("Error", message: "You are not connected to the internet")
                        self.hasBeenWarnedOfInternetConnection = true
                    }
                }
            }
        }
        task.resume()
    }
    
    func refreshTable() {
        let secretKeyString = "kjdfb4u7bksSDDF44wlksdnw33j4"
        let savedUsername = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        print("SAVED USERNAME: \(savedUsername)")
        print("ENC USERNAME: \(self.MyCryptoMachine.encryptStringToBase64(savedUsername))")
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/getMessages.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let encUsername = self.MyCryptoMachine.encryptStringToBase64(savedUsername)
        print("ENC USERNAME: '\(encUsername)'")
        print("secretKeyString: '\(secretKeyString)'")
        let postString = "username=\(encUsername)&secretKey=\(secretKeyString)"
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
                        print("RESPONSE STRING: \(responseString)")
                        if self.firstTimeThrough == true {
                            self.alertController.dismissViewControllerAnimated(true, completion: nil)
                        }
                        self.firstTimeThrough = false
                        let NSResponseString = responseString! as NSString
                        let firstThree = NSResponseString.substringWithRange(NSRange(location: 0, length: 3))
                        if responseString !== "" && firstThree == "gfg" {
                            self.hasBeenWarnedOfInternetConnection = false
                            let notGFGArray = responseString!.componentsSeparatedByString("gfg")
                            if notGFGArray[1] != "" {
                            let messageSenders = notGFGArray[1].componentsSeparatedByString("9254203598")
                            print("SENDER COUNT: \(messageSenders.count)")
                            for sender in messageSenders {
                                if sender == "" {
                                    continue
                                }
                                print("SENDER: \(sender)")
                                var doesAlreadyExist = false
                                for senderTwo in self.alreadyAddedFriends {
                                    if sender == senderTwo {
                                        doesAlreadyExist = true
                                    }
                                }
                                if doesAlreadyExist == false {
                                    //let decSender = self.MyCryptoMachine.decryptBase64ToString(sender)
                                    self.chatsPending.addObject(sender)
                                    self.alreadyAddedFriends.append(sender)
                                    self.tableView.reloadData()
                                }
                            }
                            } else {
                                
                            }
                        } else {
                            
                        }
                    }
                } else {
                    if self.hasBeenWarnedOfInternetConnection != true {
                        self.sendAlert("Error", message: "You are not connected to the internet")
                        self.hasBeenWarnedOfInternetConnection = true
                    }
                }
            }
        }
        task.resume()
        if firstTimeThrough == true {
            self.sendLoading()
        }
    }
    
    func enterChat(sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender senderObj: AnyObject?) {
        timer.invalidate()
        if(segue.identifier == "toLogin") {
            let theVC: ViewController = segue.destinationViewController as! ViewController
            theVC.shouldLogin = false
        }
        if(segue.identifier == "toChat") {
            let sender = senderObj as! UIButton
            let requestIndex = sender.tag
            let theVC: chatViewController = segue.destinationViewController as! chatViewController
            theVC.friendChosen = self.MyCryptoMachine.decryptBase64ToString(self.chatsPending.objectAtIndex(requestIndex) as! String)
        }
    }
}

