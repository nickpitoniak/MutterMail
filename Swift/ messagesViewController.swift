
import UIKit

class chatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var timer = NSTimer()
    
    var tableBackgroundInc = 1
    
    let EnigmaMachine = EncryptionMachine()
    
    var friendChosen: String!
    
    var isConnectedToInternet: Bool!
    
    var receivedUsername:String!
    
    @IBOutlet weak var testLabel: UILabel!
    
    var messageStringRecords = []
    
    var hasBeenWarnedOfInternet:Bool = false
    
    var messages: NSMutableArray = NSMutableArray()
    
    func sendAlert(subject: String, message: String) {
        let alertController = UIAlertController(title: subject, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func requiredHeight(text:String) -> CGFloat {
        let font = UIFont(name: "Georgia", size: 16.0)
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, 200, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection Section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! chatTableViewCell
        //cell.messageLabel?.text = self.messages.objectAtIndex(indexPath.row) as? String
        let wholeMessage = self.messages.objectAtIndex(indexPath.row) as? String
        if wholeMessage! as String != "Loading......" && wholeMessage! as String != "No messages" {
            let splitMessage = wholeMessage!.componentsSeparatedByString("203598123589")
            let theMessage = splitMessage[0]
            if EnigmaMachine.decrypt(splitMessage[1]) as String == friendChosen.uppercaseString as String {
                let completeMessage = friendChosen.uppercaseString + ": " + theMessage
                cell.messageLabel?.text = completeMessage
            } else {
                cell.messageLabel.textAlignment = NSTextAlignment.Right
                let completeMessage = theMessage
                cell.messageLabel?.text = completeMessage
            }
        } else {
            cell.messageLabel?.text = wholeMessage! as String
        }
        tableView.estimatedRowHeight = requiredHeight(self.messages.objectAtIndex(indexPath.row) as! String)
        tableView.rowHeight = UITableViewAutomaticDimension
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    /*@IBAction func refreshButton(sender: UIButton) {
        reloadTable()
    }*/
    
    @IBOutlet weak var messageTextInput: UITextField!
    
    @IBAction func sendButton(sender: UIButton) {
        let chatPartner = self.friendChosen
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let theMessage = messageTextInput.text! as String
        let messageTextPreOne = EnigmaMachine.encrypt(theMessage)
        let messageTextPreTwo = messageTextPreOne.stringByReplacingOccurrencesOfString(" ", withString: "039254space925403")
        let messageText = self.voidInvalidCharacters(messageTextPreTwo)
        if messageText != "" {
            let secretKey = "fsjdfb3ilu45rejd394idjnv"
            let myUrl = NSURL(string: "http://www.neverforgottenbbq.com/gfg/sendMessage.php")
            let request = NSMutableURLRequest(URL: myUrl!)
            request.HTTPMethod = "POST"
            let postString = "secretKey=\(secretKey)&username=\(username)&chatPartner=\(chatPartner)&message=\(messageText)"
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
                            print("")
                        }
                    } else {
                        print("The connection quit")
                    }
                }
            }
            
            task.resume()
        }
        
        func requiredHeight(text:String) -> CGFloat {
            let font = UIFont(name: "Georgia", size: 16.0)
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, 200, CGFloat.max))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.font = font
            label.text = text
            label.sizeToFit()
            return label.frame.height
        }
        
        func reloadTable() {
            refreshTable()
            self.messages = []
            let chatPartner = NSUserDefaults.standardUserDefaults().stringForKey("usernameToMessageWith")! as String
            let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
            let myUrl = NSURL(string: "http://www.neverforgottenbbq.com/gfg/getMessagesForCurrentChat.php")
            let request = NSMutableURLRequest(URL: myUrl!)
            request.HTTPMethod = "POST"
            let postString = "username=\(username)&chatPartner=\(chatPartner)"
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
                            self.messageStringRecords = responseString!.componentsSeparatedByString("3292985383")
                            for index in self.messageStringRecords {
                                let indexSplit = index.componentsSeparatedByString("9254203598")
                                if indexSplit.count > 1 {
                                    let theMessage = indexSplit[0]
                                    let messageId = indexSplit[1]
                                    self.updateReadStatus(messageId)
                                    let theNewMessage = theMessage
                                    self.messages.addObject(self.EnigmaMachine.decrypt(theNewMessage))
                                    self.tableBackgroundInc = 1
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    } else {
                        print("The connection quit")
                    }
                }
            }
            
            task.resume()
            self.tableView.estimatedRowHeight = 44.0
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableBackgroundInc = 1
            self.tableView.reloadData()
        }
    }
    
    func updateReadStatus(messageId: String) {
        let theSecretKey = "kjdfb4u7bksSDDF44wlksdnw33j4"
        let myUrl = NSURL(string: "http://www.neverforgottenbbq.com/gfg/updateReadStatus.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "id=\(messageId)&secretKey=\(theSecretKey)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                
                if let responseData = data {
                    
                    _ = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                    if error != nil {
                        print("Error: \(error)")
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        print("")
                    }
                } else {
                    print("The connection quit")
                }
            }
        }
        
        task.resume()
    }
    
    func voidInvalidCharacters(stringToVoid: String) -> String {
        var returnString = ""
        var sanitizedArray: [String] = []
        let acceptableCharacters = [
            "A",
            "B",
            "C",
            "D",
            "E",
            "F",
            "G",
            "H",
            "I",
            "J",
            "K",
            "L",
            "M",
            "N",
            "O",
            "P",
            "Q",
            "R",
            "S",
            "T",
            "U",
            "V",
            "W",
            "X",
            "Y",
            "Z",
            "a",
            "b",
            "c",
            "d",
            "e",
            "f",
            "g",
            "h",
            "i",
            "j",
            "k",
            "l",
            "m",
            "n",
            "o",
            "p",
            "q",
            "r",
            "s",
            "t",
            "u",
            "v",
            "w",
            "x",
            "y",
            "z",
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "-",
            ".",
            "_",
            "~",
            ":",
            "/",
            "?",
            "#",
            "[",
            "]",
            "@",
            "!",
            "$",
            "'",
            "(",
            ")",
            "*",
            "+",
            ",",
            ";",
            "="
        ]
        let stringToVoidArray = Array(stringToVoid.characters)
        for letter in stringToVoidArray {
            var isAcceptable = false
            for character in acceptableCharacters {
                if character as String == String(letter) {
                    isAcceptable = true
                }
            }
            if isAcceptable == true {
                sanitizedArray.append(String(letter))
            }
        }
        for letter in sanitizedArray {
            returnString = returnString + letter
        }
        return returnString
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func dismissKeyboard() {
        self.messageTextInput.resignFirstResponder()
    }
    func refreshTable () {
        print("mmmmm 2refreshing!")
        let newMessages: NSMutableArray = NSMutableArray()
        let chatPartner = self.receivedUsername
        if chatPartner == "" {
            self.sendAlert("Error", message: "Can not connect to chat partner")
        }
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let myUrl = NSURL(string: "http://www.neverforgottenbbq.com/gfg/getMessagesForCurrentChat.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "username=\(username)&chatPartner=\(chatPartner)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                
                if let _ = data {
                self.hasBeenWarnedOfInternet = false
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                if error != nil {
                    print("Error: \(error)")
                }
                dispatch_async(dispatch_get_main_queue()) {
                    let NSResponseString = responseString! as NSString
                    let firstThree = NSResponseString.substringWithRange(NSRange(location: 0, length: 3))
                    if responseString !== "" && firstThree == "gfg" {
                        let minusVerificationArray = responseString!.componentsSeparatedByString("tuttuttut")
                        self.messageStringRecords = minusVerificationArray[1].componentsSeparatedByString("3292985383")
                        print("WHATS THE COUNT, BEN CAMPBELL? IT'S \(minusVerificationArray.count)")
                        for index in self.messageStringRecords {
                            let indexSplit = index.componentsSeparatedByString("9254203598")
                            let theMessage = indexSplit[0]
                            let theNewMessagePre = theMessage.stringByReplacingOccurrencesOfString("039254space925403", withString: " ")
                            let theNewMessage = theNewMessagePre + "203598123589\(String(indexSplit[3]))"
                            newMessages.addObject(self.EnigmaMachine.decrypt(theNewMessage))
                        }
                        self.messages = []
                        for i in newMessages {
                            self.messages.addObject(i)
                        }
                        self.tableBackgroundInc = 1
                        self.tableView.reloadData()
                    } else {
                        self.messages = []
                        self.messages.addObject("No messages")
                        self.tableView.reloadData()
                    }
                }
                } else {
                    if self.hasBeenWarnedOfInternet != true {
                        self.sendAlert("Error", message: "You are not connected to the internet")
                        self.hasBeenWarnedOfInternet = true
                    }
                }
            }
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            UIApplicationUserDidTakeScreenshotNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue())
            {
                notification in
                2
                let chatPartner = self.friendChosen
                let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
                let theMessage = "I took a screenshot. I am sorry that I cannot be trusted :("
                let messageTextPreOne = self.EnigmaMachine.encrypt(theMessage)
                let messageTextPreTwo = messageTextPreOne.stringByReplacingOccurrencesOfString(" ", withString: "039254space925403")
                let messageText = self.voidInvalidCharacters(messageTextPreTwo)
                if messageText != "" {
                    let secretKey = "fsjdfb3ilu45rejd394idjnv"
                    let myUrl = NSURL(string: "http://www.neverforgottenbbq.com/gfg/sendMessage.php")
                    let request = NSMutableURLRequest(URL: myUrl!)
                    request.HTTPMethod = "POST"
                    let postString = "secretKey=\(secretKey)&username=\(username)&chatPartner=\(chatPartner)&message=\(messageText)"
                    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                        data, response, error in
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                            _ = NSString(data: data!, encoding: NSUTF8StringEncoding) // lazy responseString: NSString
                            if error != nil {
                                print("Error: \(error)")
                            }
                            dispatch_async(dispatch_get_main_queue()) {
                                //print(responseString)
                            }
                        }
                    }
                    task.resume()
                } else {
                    self.sendAlert("Error", message: "You cannot send a blank message")
                }
        }
        self.receivedUsername = friendChosen
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        self.messages.addObject("Loading......")
        refreshTable()
        print("this is a test")
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("refreshTable"), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        timer.invalidate()
    }
}