
import UIKit

class chatViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var screenshotsLabel: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var encryptTextField: UITextField!
    @IBOutlet weak var decryptTextField: UITextField!
    @IBOutlet weak var messageTextInput: UITextField!
    
    let MyCryptoMachine = CryptoMachine()
    let MyFunctionMachine = FunctionMachine()
    
    var tableBackgroundInc = 1
    var timesEntered = 1
    var canTakeScreenshot = true
    var timer = NSTimer()
    let usernameForDeletion = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
    var friendChosen: String!
    var messageToReport = ""
    var isConnectedToInternet: Bool!
    var encryptionPass: String!
    var successfulDecryption:Bool = false
    var blockActive = false
    var receivedUsername:String!
    var currentMessageIds = [String]()
    var keyboardHeight: Int!
    var messageStringRecords = []
    var keyboardIsShowing:Bool = false
    var usersBanned = false
    var screenshotActive = false
    var hasBeenWarnedOfInternet:Bool = false
    var messages: NSMutableArray = NSMutableArray()
    
    @IBAction func destroyMessages(sender: UIButton) {
        let encUsername = self.MyCryptoMachine.encryptStringToBase64(self.usernameForDeletion)
        let encChatPartner = self.MyCryptoMachine.encryptStringToBase64(self.friendChosen)
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/deleteMessagesById.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "username=\(encUsername)&chatPartner=\(encChatPartner)&secretKey=kjdfb4u7bksSDDF44wlksdnw33j4"
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
                        print("\n\n\n\n\n\n\(responseString)\n\n\n\n\n")
                    }
                }
            }
        }
        task.resume()
    }
    
    // Create the alert controller
    var alert = UIAlertController(title: "Flag message for abuse", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    
    func sendAlert(subject: String, message: String) {
        let alertController = UIAlertController(title: subject, message: message, preferredStyle: UIAlertControllerStyle.Alert)
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
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let wholeMessage = self.messages.objectAtIndex(indexPath.row) as? String
        cell.messageButton.titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        if wholeMessage! as String != "Loading......" && wholeMessage! as String != "No messages" {
            let splitMessage = wholeMessage!.componentsSeparatedByString("203598123589")
            let theMessage = splitMessage[0]
            let decFriendChosen = friendChosen
            if splitMessage[1].uppercaseString == decFriendChosen.uppercaseString as String {
                cell.messageButton.tag = indexPath.row
                cell.messageButton.titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping;
                cell.messageButton.addTarget(self, action: "messageClick:", forControlEvents: .TouchUpInside)
                cell.messageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
                let completeMessage = theMessage
                cell.messageButton.setTitle(completeMessage, forState: .Normal)
                cell.messageButton.titleLabel!.textColor = UIColor.blackColor()
                if cell.messageButton.currentTitle == "This message is encrypted" {
                    cell.messageButton.setTitle("This message is encrypted", forState: .Normal)
                    cell.messageButton.titleLabel!.textColor = UIColor.orangeColor()
                }
                if cell.messageButton.currentTitle == "I took a screenshot" {
                    cell.messageButton.setTitle("\(friendChosen) took a screenshot", forState: .Normal)
                   cell.messageButton.titleLabel!.textColor = UIColor.redColor()
                }
            } else if splitMessage[1].uppercaseString as String == username.uppercaseString as String {
                cell.messageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
                let completeMessage = /*username.uppercaseString + ": " + */theMessage//.lowercaseString
                cell.messageButton.setTitle(completeMessage, forState: .Normal)
                cell.messageButton.titleLabel!.textColor = UIColor(red:79.0/255.0, green:79.0/255.0, blue:79.0/255.0, alpha:1.0)
                if cell.messageButton.currentTitle == "This message is encrypted" {
                    cell.messageButton.setTitle("This message is encrypted", forState: .Normal)
                    cell.messageButton.titleLabel!.textColor = UIColor.orangeColor()
                }
                if cell.messageButton.currentTitle == "I took a screenshot" {
                    cell.messageButton.setTitle("\(username) took a screenshot", forState: .Normal)
                   cell.messageButton.titleLabel!.textColor = UIColor.redColor()
                }
            } else {
                print("NONE FOUND")
            }
        } else {
            cell.messageButton.setTitle(wholeMessage! as String, forState: .Normal)
        }
        tableView.estimatedRowHeight = requiredHeight(self.messages.objectAtIndex(indexPath.row) as! String)
        tableView.rowHeight = UITableViewAutomaticDimension
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    @IBAction func messageClick(sender: UIButton) {
        let message = self.messages.objectAtIndex(sender.tag) as? String
        self.messageToReport = message!
        let messageArray = self.messageToReport.componentsSeparatedByString("203598123589")
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        if messageArray[1] == username {
            return
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func decryptButton(sender: UIButton!) {
        if Reachability.isConnectedToNetwork() == false {
            self.sendAlert("Error", message: "You must be connected the the internet to use this application")
            return
        }
        let decryptionKey = self.decryptTextField.text
        if decryptionKey == "" {
            self.sendAlert("Error", message: "Your decryption key is blank")
            return
        }
        
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let encUsername = self.MyCryptoMachine.encryptStringToBase64(username)
        let encChatPartner = self.MyCryptoMachine.encryptStringToBase64(friendChosen)
        
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/getMessagesForCurrentChat.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "username=\(encUsername)&chatPartner=\(encChatPartner)"
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
                    print("RS FROM DECRYPTION \(responseString)")
                    let NSResponseString = responseString! as NSString
                    let firstThree = NSResponseString.substringWithRange(NSRange(location: 0, length: 3))
                    if responseString as! String == "error" {
                        self.sendAlert("Error", message: "Unable to fetch messages")
                        return
                    }
                    if responseString as! String == "gfggfgfgf" {
                        self.sendAlert("No messages to decrypt", message: "")
                    }
                    if responseString as! String != "gfggfgfgf" && firstThree == "gfg" && responseString !== "" {
                        let minusVerificationArray = responseString!.componentsSeparatedByString("gfggfgfgf")
                        if minusVerificationArray.count > 1 {
                            if minusVerificationArray[1] != "" {
                                let wholeMessages = minusVerificationArray[1].componentsSeparatedByString("3292985383")
                                var messageCounter = 0
                                var hasDecrypted = false
                                var messageArrayLength = wholeMessages.count
                                print("LENGTH: \(messageArrayLength)")
                                print("COUNTER: \(messageCounter)")
                                for index in wholeMessages {
                                    messageCounter = messageCounter + 1
                                    let indexSplit = index.componentsSeparatedByString("9254203598")
                                    let author = self.MyCryptoMachine.decryptBase64ToString(String(indexSplit[3]))
                                    let theId = indexSplit[1]
                                    let hasBeenDecrypted = indexSplit[4]
                                    let emptyEncryption = self.MyCryptoMachine.encryptStringToBase64("29284hfnfj9s9s0s0f8FFrwq9")
                                    var messageEncryption = indexSplit[5]
                                    let decryptionKeyEncrypted = self.MyCryptoMachine.encryptStringToBase64(decryptionKey!)
                                    if author != self.friendChosen {
                                        if messageCounter == messageArrayLength && hasDecrypted == false {
                                            self.sendAlert("No messages were decrypted", message: "")
                                        }
                                        continue
                                    }
                                    if hasBeenDecrypted == "yes" {
                                        if messageCounter == messageArrayLength && hasDecrypted == false {
                                            self.sendAlert("No messages were decrypted", message: "")
                                        }
                                        continue
                                    }
                                    if messageEncryption == emptyEncryption {
                                        if messageCounter == messageArrayLength && hasDecrypted == false {
                                            self.sendAlert("No messages were decrypted", message: "")
                                        }
                                        continue
                                    }
                                    if messageEncryption == decryptionKeyEncrypted {
                                        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/updateEncryptionStatus.php?id=\(theId)")
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
                                                    if responseString as String! == "success" {
                                                        self.sendAlert("Success", message: "Message decrypted")
                                                        hasDecrypted = true
                                                        self.successfulDecryption = true
                                                    }
                                                }
                                            }
                                        }
                                        task.resume()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        }
        task.resume()
    }

    @IBAction func sendButton(sender: UIButton) {
        if self.encryptTextField.text == "" {
            self.encryptionPass = self.MyCryptoMachine.encryptStringToBase64("29284hfnfj9s9s0s0f8FFrwq9")
        } else {
            self.encryptionPass = self.MyCryptoMachine.encryptStringToBase64(self.encryptTextField.text!)
        }
        if self.usersBanned == true {
            self.sendAlert("Cannot Send Message", message: "User has been banned")
            return
        }
        let chatPartner = self.friendChosen
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let encUsername = self.MyCryptoMachine.encryptStringToBase64(username)
        let encChatPartner = self.MyCryptoMachine.encryptStringToBase64(chatPartner)
        
        let theMessage = messageTextInput.text! as String
        if theMessage == "" {
            self.sendAlert("Error", message: "You cannot send an empty message")
            return
        }
        if theMessage.characters.count > 2500 {
            self.sendAlert("Error", message: "Message may not exceed 2500 characters in length")
            return
        }
        
        if self.blockActive == true {
            self.sendAlert("Block active", message: "Cannot send message")
            return
        }
        
        
        
        
        let theMessageEnc = self.MyCryptoMachine.encryptStringToBase64(theMessage)
        if theMessageEnc != "" {
            let secretKey = "fsjdfb3ilu45rejd394idjnv"
            let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/sendMessage.php")
            let request = NSMutableURLRequest(URL: myUrl!)
            request.HTTPMethod = "POST"
            print("KEY: \(secretKey)")
            print("ENC USERNAME: \(encUsername)")
            print("MESSAGE: \(theMessageEnc)")
            let postString = "secretKey=\(secretKey)&username=\(encUsername)&chatPartner=\(encChatPartner)&message=\(theMessageEnc)&encryption=\(self.encryptionPass)"
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
                            self.messageTextInput.text = ""
                            self.encryptTextField.text = ""
                            print("made it through")
                        }
                    } // end data return check
                } // end first dispatch
            } // end NSURLSession instantiation
            task.resume()
        } // if checking that message
    }
    
    func updateReadStatus(messageId: String) {
        let theSecretKey = "kjdfb4u7bksSDDF44wlksdnw33j4"
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/updateReadStatus.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "id=\(messageId)&secretKey=\(theSecretKey)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                if let responseData = data {
                    let _ = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                    if error != nil {
                        print("Error: \(error)")
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        
                    }
                } // end return data check
            } // end first dispatch
        } // end NSURLSession instantiation
        task.resume()
    }
    
    func refreshTable () {
        if self.messages.count == 1 {
            if self.messages[0] as! String == "Loading......" {
                self.messages = NSMutableArray()
            }
        }
        let newMessages: NSMutableArray = NSMutableArray()
        let chatPartner = self.receivedUsername
        if chatPartner == "" {
            self.sendAlert("Error", message: "Can not connect to chat partner")
        }
        
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let encUsername = self.MyCryptoMachine.encryptStringToBase64(username)
        let encChatPartner = self.MyCryptoMachine.encryptStringToBase64(friendChosen)
        
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/getMessagesForCurrentChat.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        print("ENC USERNAME: \(encUsername)")
        print("ENC ChatPartner: \(encChatPartner)")
        let postString = "username=\(encUsername)&chatPartner=\(encChatPartner)"
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
                        print("Response string: \(responseString)")
                        let NSResponseString = responseString! as NSString
                        let firstThree = NSResponseString.substringWithRange(NSRange(location: 0, length: 3))
                        if responseString as! String == "error" {
                            self.sendAlert("Error", message: "Unable to fetch messages")
                            return
                        }
                        if responseString as! String != "gfggfgfgf" && firstThree == "gfg" && responseString !== "" {
                            let minusVerificationArray = responseString!.componentsSeparatedByString("gfggfgfgf")
                            if minusVerificationArray.count > 1 {
                                if minusVerificationArray[1] != "" {
                            self.currentMessageIds = []
                            self.messageStringRecords = []
                            self.messageStringRecords = minusVerificationArray[1].componentsSeparatedByString("3292985383")
                            for index in self.messageStringRecords {
                                let indexSplit = index.componentsSeparatedByString("9254203598")
                                self.currentMessageIds.append(indexSplit[1])
                                var theMessage = self.MyCryptoMachine.decryptBase64ToString(indexSplit[0])
                                if indexSplit[2] == "0" && indexSplit[3] != encUsername {
                                    self.updateReadStatus(indexSplit[1])
                                }
                                let author = self.MyCryptoMachine.decryptBase64ToString(String(indexSplit[3]))
                                let hasBeenDecrypted = indexSplit[4]
                                let emptyEncryption = self.MyCryptoMachine.encryptStringToBase64("29284hfnfj9s9s0s0f8FFrwq9")
                                let messageEncryption = indexSplit[5]
                                if hasBeenDecrypted == "no" && messageEncryption != emptyEncryption {
                                    theMessage = "This message is encrypted"
                                }
                                let theNewMessage = theMessage + "203598123589\(author)"
                                newMessages.addObject(theNewMessage)
                            }
                                    for m in newMessages {
                                        print(m)
                                    }
                            self.messages = []
                            for i in newMessages {
                                self.messages.addObject(i)
                            }
                            self.tableBackgroundInc = 1
                            self.tableView.reloadData()
                            }
                            } else {

                            }
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
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if keyboardIsShowing == false {
                self.keyboardHeight = Int(keyboardSize.height)
                self.view.frame.origin.y -= keyboardSize.height
                keyboardIsShowing = true
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if keyboardIsShowing == true {
                self.view.frame.origin.y += CGFloat(self.keyboardHeight)
                keyboardIsShowing = false
            }
        }
    }
    
    func dismissKeyboard() {
        self.messageTextInput.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "Report", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
            
            
            let messageReplaced = self.messageToReport.stringByReplacingOccurrencesOfString("203598123589", withString: " by: ", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let theSecretKey = "kjdfb4u7bksSDDF44wlksdnw33j4"
            let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/flagMessage.php")
            let request = NSMutableURLRequest(URL: myUrl!)
            request.HTTPMethod = "POST"
            let postString = "flaggedMessage=\(self.MyCryptoMachine.encryptStringToBase64(messageReplaced))&secretKey=\(theSecretKey)"
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
                            print("RESPONSE STRINGG: \(responseString)")
                            if responseString as! String == "success" {
                                self.sendAlert("Success", message: "Message resported")
                            }
                        }
                    } // end return data check
                } // end first dispatch
            } // end NSURLSession instantiation
            task.resume()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.messageTextInput.delegate = self;
        self.encryptTextField.delegate = self;
        self.decryptTextField.delegate = self;
        self.receivedUsername = friendChosen
        NSNotificationCenter.defaultCenter().addObserverForName(
            UIApplicationUserDidTakeScreenshotNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue()) {
                notification in
                2
                let messageTextFirst = "I took a screenshot"
                let messageText = self.MyCryptoMachine.encryptStringToBase64(messageTextFirst)
                let messageTextNoPlus = messageText.stringByReplacingOccurrencesOfString("+", withString: "8189781897plus8189781897", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let messageTextNoEquals = messageTextNoPlus.stringByReplacingOccurrencesOfString("=", withString: "49387738392equals393847473", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let messageTextNoSlash = messageTextNoEquals.stringByReplacingOccurrencesOfString("/", withString: "9360412slash9360412", options: NSStringCompareOptions.LiteralSearch, range: nil)
                if messageText != "" {
                    let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
                    let secretKey = "fsjdfb3ilu45rejd394idjnv"
                    let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/sendMessage.php")
                    let request = NSMutableURLRequest(URL: myUrl!)
                    request.HTTPMethod = "POST"
                    let postStringTwo = "secretKey=\(secretKey)&username=\(username)&chatPartner=\(self.receivedUsername)&message=\(messageTextNoSlash)"
                    request.HTTPBody = postStringTwo.dataUsingEncoding(NSUTF8StringEncoding)
                    let taskTwo = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                        data, response, error in
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                            if let responseData = data {
                                _ = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                            if error != nil {
                                print("Error: \(error)")
                            }
                            dispatch_async(dispatch_get_main_queue()) {
                                
                            }
                            } else {
                                self.sendAlert("Error", message: "You are not connectd to the internet")
                            }
                        }
                    }
                    taskTwo.resume()
                }
        }
        
        let username = NSUserDefaults.standardUserDefaults().stringForKey("username")! as String
        let encUsername = self.MyCryptoMachine.encryptStringToBase64(username)
        
        let secretKey = "fsjdfb3ilu45rejd394idjnv"
        let myUrl = NSURL(string: "http://www.nickpitoniak.com/gone/checkForBan.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "secretKey=\(secretKey)&username=\(encUsername)"
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
                        print("\n\n\n\n\n\n\nTHE RS: \(responseString)\n\n\n\n\n\n\n\n\n")
                        if responseString as! String == "banned" {
                            self.usersBanned = true
                        }
                    }
                } // end data return check
            } // end first dispatch
        } // end NSURLSession instantiation
        task.resume()
        
        let secretKeyTwo = "fsjdfb3ilu45rejd394idjnv"
        let myUrlTwo = NSURL(string: "http://www.nickpitoniak.com/gone/checkForBan.php")
        let requestTwo = NSMutableURLRequest(URL: myUrlTwo!)
        requestTwo.HTTPMethod = "POST"
        let encFriendChosen = self.MyCryptoMachine.encryptStringToBase64(self.friendChosen)
        print("999\(encFriendChosen)")
        let postStringTwo = "secretKey=\(secretKeyTwo)&username=\(encFriendChosen)"
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
                        print("\n\n\n\n\n\n\nTHE RS: \(responseString)\n\n\n\n\n\n\n\n\n")
                        if responseString as! String == "banned" {
                            self.usersBanned = true
                        }
                    }
                } // end data return check
            } // end first dispatch
        } // end NSURLSession instantiation
        taskTwo.resume()
        
        let secretKeyThree = "fsjdfb3ilu45rejd394idjnv"
        let myUrlThree = NSURL(string: "http://www.nickpitoniak.com/gone/checkForBlock.php")
        let requestThree = NSMutableURLRequest(URL: myUrlThree!)
        requestThree.HTTPMethod = "POST"
        let encFriendChosenThree = self.MyCryptoMachine.encryptStringToBase64(self.friendChosen)
        let postStringThree = "secretKey=\(secretKeyThree)&username=\(encUsername)&chatPartner=\(encFriendChosenThree)"
        requestThree.HTTPBody = postStringThree.dataUsingEncoding(NSUTF8StringEncoding)
        let taskThree = NSURLSession.sharedSession().dataTaskWithRequest(requestThree) {
            data, response, error in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                if let responseData = data {
                    let responseString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                    if error != nil {
                        print("Error: \(error)")
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        print("\n\n\n\n\n\n\nTHE RSI: \(responseString)\n\n\n\n\n\n\n\n\n")
                        if responseString as! String == "yes" {
                            self.blockActive = true
                        }
                    }
                } // end data return check
            } // end first dispatch
        } // end NSURLSession instantiation
        taskThree.resume()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        self.messages.addObject("Loading......")
        print("FC: '\(self.friendChosen)'")
        self.refreshTable()
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