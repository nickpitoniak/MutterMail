
import UIKit
import CryptoSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var passwordInput: UITextField!
    @IBAction func rememberMeSwitch(sender: AnyObject) {
        var rememberDefault = NSUserDefaults.standardUserDefaults().stringForKey("rememberDefault")
        if rememberDefault == "yes" {
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "rememberDefault")
            rememberDefault = NSUserDefaults.standardUserDefaults().stringForKey("rememberDefault")
            print("Default: \(rememberDefault)")
        }
        else if rememberDefault == nil {
            NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "rememberDefault")
            rememberDefault = NSUserDefaults.standardUserDefaults().stringForKey("rememberDefault")
            print("Default: \(rememberDefault)")
        }
        else {
            self.sendAlert("Error", message: "Unable to utilize automatic login")
            return
        }
    }
    @IBAction func createAccountButton(sender: UIButton) {
        
    }
    
    let MyCryptoMachine = CryptoMachine()
    let MyFunctionMachine = FunctionMachine()
    let MyConnectionMachine = ConnectionMachine()
    
    var alertController: UIAlertController!
    var keyboardHeight: Int!
    var keyboardIsShowing:Bool = false
    var shouldLogin: Bool = true
    var isConnectedToInternet: Bool!
    var hasPressedLogin: Bool = false
    var loadingView: UIView = UIView()
    var textFieldMoved = false
    var container: UIView = UIView()
    
    func logout() {
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "id")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "password")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func sendLoading() {
        self.alertController = UIAlertController(title: "Loading...", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func loginButton(sender: UIButton) {
        if hasPressedLogin == true {
            self.sendAlert("Error", message: "You may only log in once")
            return
        }
        
        hasPressedLogin = true
        
        if Reachability.isConnectedToNetwork() == false {
            self.sendAlert("Error", message: "You must be connected to the internet to use this application")
            self.hasPressedLogin = false
            return
        }
        
        // sanitize input prior to PHP connection
        if usernameInput.text == "" || passwordInput.text == "" {
            self.sendAlert("Error", message: "You must populate all fields")
            self.hasPressedLogin = false
            return
        }
        if usernameInput.text!.characters.count < 6 || passwordInput.text!.characters.count < 6 {
            self.sendAlert("Error", message: "Username and password must be greater than 5 characters")
            self.hasPressedLogin = false
            return
        }
        /*
        if MyFunctionMachine.basicAcceptableCharacters(usernameInput.text!) || MyFunctionMachine.basicAcceptableCharacters(passwordInput.text!) {
            self.sendAlert("Error", message: "Your submission contains invalid characters\nPlease try again")
            return
        }
        */
        // encrypt username and password input
        let usernameInputRaw = usernameInput.text! as String
        let encUsername = MyCryptoMachine.encryptStringToBase64(usernameInputRaw.lowercaseString)
        let encPassword = MyCryptoMachine.encryptStringToBase64(passwordInput.text! as String)

        //let alertController : UIAlertController
        
        print("about to check")
        
        let secretKey = "fsjdfb3ilu45rejd394idjnv"
        let myURLFirst = NSURL(string: "http://www.nickpitoniak.com/gone/checkForBan.php")
        let requestFirst = NSMutableURLRequest(URL: myURLFirst!)
        requestFirst.HTTPMethod = "POST"
        let postStringFirst = "secretKey=\(secretKey)&username=\(encUsername)"
        requestFirst.HTTPBody = postStringFirst.dataUsingEncoding(NSUTF8StringEncoding)
        let taskFirst = NSURLSession.sharedSession().dataTaskWithRequest(requestFirst) {
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
                            self.sendAlert("Account Banned", message: "Cannot Login")
                            return
                        }
                    }
                } // end data return check
            } // end first dispatch
        } // end NSURLSession instantiation
        taskFirst.resume()
        
        
        // connect to PHP login script
        let myUrl = NSURL(string: "http://nickpitoniak.com/gone/login.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "username=\(encUsername)&password=\(encPassword)&secretKey=kjdfb4u7bksSDDF44wlksdnw33j4"
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
                        if String(responseString) == "error" {
                            self.sendAlert("Error", message: "Unable to login")
                            self.hasPressedLogin = false
                            return
                        }
                        if String(responseString) == "banned" {
                            self.sendAlert("Error", message: "This account has been banned due to innapropriate activity")
                            self.hasPressedLogin = false
                            return
                        }
                        if String(responseString).characters.count < 5 {
                            self.sendAlert("Error", message: "Unable to login")
                            self.hasPressedLogin = false
                            return
                        }
                        if (String(responseString).lowercaseString.rangeOfString("error") != nil) {
                            self.sendAlert("Error", message: "Unable to login")
                            self.hasPressedLogin = false
                            return
                        }
                        if (String(responseString).lowercaseString.rangeOfString("success") == nil) {
                            self.sendAlert("Error", message: "Unable to login. Please try again later")
                            self.hasPressedLogin = false
                            return
                        }
                        let userInfo = responseString!.componentsSeparatedByString("9254203598")
                        let userInfoCount = userInfo.count
                        if userInfoCount != 4 {
                            self.hasPressedLogin = false
                            self.sendAlert("Error", message: "Unable to login")
                            return
                        }
                        let userInfoId = userInfo[1] as String
                        let userInfoUsername = self.MyCryptoMachine.decryptBase64ToString(userInfo[2] as String)
                        let userInfoPasswordPreReplace = userInfo[3] as String
                        let userInfoPassword = userInfoPasswordPreReplace.stringByReplacingOccurrencesOfString("success", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        NSUserDefaults.standardUserDefaults().setObject(userInfoId, forKey: "id")
                        NSUserDefaults.standardUserDefaults().setObject(userInfoUsername, forKey: "username")
                        NSUserDefaults.standardUserDefaults().setObject(userInfoPassword, forKey: "password")
                        self.usernameInput.text = ""
                        self.passwordInput.text = ""
                        NSUserDefaults.standardUserDefaults().stringForKey("username")
                        self.segueToMessages()
                    } // end of main dispatch
                } // check if responseData returned
            } // first dispatch
        } // NSURLSession instantiation
        task.resume()
    } // end of @IBAction loginButton
    
    func dismissKeyboard() {
        self.usernameInput.resignFirstResponder()
        self.passwordInput.resignFirstResponder()
    }
    
    func segueToMessages() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("messagesVC")     as! messagesViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if textFieldMoved == false {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                if keyboardIsShowing == false {
                    self.keyboardHeight = Int(keyboardSize.height)
                    self.view.frame.origin.y -= keyboardSize.height
                    keyboardIsShowing = true
                }
            }
            textFieldMoved = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if textFieldMoved == true {
            if keyboardIsShowing == true {
                self.view.frame.origin.y += CGFloat(self.keyboardHeight)
                keyboardIsShowing = false
            }
        }
        textFieldMoved = false
    }
    
    func sendAlert(subject: String, message: String) {
            let alertController = UIAlertController(title: subject, message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.welcomeLabel.alpha = 0.0
        welcomeLabel.text = "Relax\n\nYou can say whatever you want"
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.welcomeLabel.alpha = 1.0
            }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // keyboard handeling
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
        print(shouldLogin)
        let usernameDefault = NSUserDefaults.standardUserDefaults().stringForKey("username")
        let passwordDefault = NSUserDefaults.standardUserDefaults().stringForKey("password")
        let rememberDefault = NSUserDefaults.standardUserDefaults().stringForKey("rememberDefault")
        if rememberDefault != nil {
            print("s1")
            if rememberDefault! as String == "yes" {
                print("s2")
                print("p \(usernameDefault)")
                print("u \(passwordDefault)")
                self.rememberMeSwitch.setOn(true, animated: true)
                if shouldLogin != false {
                if usernameDefault == nil || passwordDefault == nil || passwordDefault == "" || usernameDefault == "" {
                    //self.sendAlert("Error", message: "Unable to log in automatically")
                    return
                }
                print("s3")
                if self.MyFunctionMachine.testForInvalidCharacters(usernameDefault!) || self.MyFunctionMachine.testForInvalidCharacters(passwordDefault!) {
                    self.sendAlert("Error", message: "Unable to log in automatically")
                    return
                }
                    print("s4")
                let myUrl = NSURL(string: "http://nickpitoniak.com/gone/login.php")
                let request = NSMutableURLRequest(URL: myUrl!)
                request.HTTPMethod = "POST"
                let encUsernameDefault = self.MyCryptoMachine.encryptStringToBase64(usernameDefault!) as String
                let encPasswordDefaultt = passwordDefault! as String
                let encPasswordDefault = encPasswordDefaultt.stringByReplacingOccurrencesOfString("success", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                print("username: \(encUsernameDefault)")
                print("password:\(encPasswordDefault)")
                let postString = "username=\(encUsernameDefault)&password=\(encPasswordDefault)&secretKey=kjdfb4u7bksSDDF44wlksdnw33j4"
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
                                print("RS: \(responseString)")
                                if String(responseString) == "error" {
                                    self.sendAlert("Error", message: "Unable to login")
                                    return
                                }
                                if String(responseString).characters.count < 5 {
                                    self.sendAlert("Error", message: "Unable to login")
                                    return
                                }
                                if (String(responseString).lowercaseString.rangeOfString("error") != nil) {
                                    self.sendAlert("Error", message: "Unable to login")
                                    return
                                }
                                if (String(responseString).lowercaseString.rangeOfString("success") == nil) {
                                    self.sendAlert("Error", message: "Unable to login automatically. Please try again later")
                                    return
                                }
                                let userInfoAuto = responseString!.componentsSeparatedByString("9254203598")
                                let userInfoAutoCount = userInfoAuto.count
                                if userInfoAutoCount != 4 {
                                    self.sendAlert("Error", message: "Unable to automatically log in")
                                    return
                                }
                                let userInfoAutoId = userInfoAuto[1] as String
                                let userInfoAutoUsername = self.MyCryptoMachine.decryptBase64ToString(userInfoAuto[2] as String)
                                let userInfoAutoPassword = userInfoAuto[3] as String
                                NSUserDefaults.standardUserDefaults().setObject(userInfoAutoId, forKey: "id")
                                NSUserDefaults.standardUserDefaults().setObject(userInfoAutoUsername, forKey: "username")
                                NSUserDefaults.standardUserDefaults().setObject(userInfoAutoPassword, forKey: "password")
                                NSUserDefaults.standardUserDefaults().stringForKey("username")
                                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("messagesVC")     as! messagesViewController
                                self.presentViewController(controller, animated: true, completion: nil)
                            }
                        }
                    }
                }
                task.resume()
            }
            }
        }
        self.logout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

