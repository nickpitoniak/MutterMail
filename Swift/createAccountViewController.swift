
import UIKit

class createAccountViewController: UIViewController {
    
    //@IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    //@IBOutlet weak var chooseUsername: UITextField!
    @IBOutlet weak var chooseUsername: UITextField!
    //@IBOutlet weak var choosePassword: UITextField!
    @IBOutlet weak var choosePassword: UITextField!
    //@IBOutlet weak var choosePasswordTwo: UITextField!
    @IBOutlet weak var choosePasswordTwo: UITextField!
    
    let MyFunctionMachine = FunctionMachine()
    let MyCryptoMachine = CryptoMachine()
    
    var isConnectedToInternet: Bool!
    var keyboardHeight: Int!
    var createAccountButtonPressed: Bool = false
    var keyboardIsShowing:Bool = false
    var textFieldMoved = false
    let reservedStrings = ["2035", "9254"]
    
    @IBAction func createAccountButton(sender: UIButton) {
        if Reachability.isConnectedToNetwork() != true {
            self.sendAlert("Error", message: "You are not connected to the internet")
            self.createAccountButtonPressed = false
            return
        }
        if createAccountButtonPressed == true {
            self.sendAlert("Error", message: "You may only create one account at a time")
            return
        }
        createAccountButtonPressed = true
        self.logout()
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "username")
        let inputUsernameRaw = chooseUsername.text as String!
        let inputUsername = inputUsernameRaw.lowercaseString
        let inputPassword = choosePassword.text as String!
        let inputPasswordTwo = choosePasswordTwo.text as String!
        if chooseUsername.text == "" || choosePassword.text == "" || choosePasswordTwo.text == "" {
            self.sendAlert("Error", message: "You must populate all fields to create an account")
            self.createAccountButtonPressed = false
            return
        }
        /*if MyFunctionMachine.basicAcceptableCharacters(chooseUsername.text! as String) ||
        MyFunctionMachine.basicAcceptableCharacters(choosePassword.text! as String) ||
        MyFunctionMachine.basicAcceptableCharacters(choosePassword.text! as String) {
        self.sendAlert("Error", message: "Your submission contains invalid characters that pose a security risk.\nPlease try again")
        return
        }*/
        let inputArray = [inputUsername, inputPassword, inputPasswordTwo]
        var doesContainRestrictedWords = false
        for word in self.reservedStrings {
            for input in inputArray {
                if input.lowercaseString.rangeOfString(word) != nil {
                    doesContainRestrictedWords = true
                }
            }
        }
        if doesContainRestrictedWords == true {
            self.sendAlert("Error", message: "Please try another username password combination")
            self.createAccountButtonPressed = false
            return
        }
        if choosePassword.text != choosePasswordTwo.text {
            self.sendAlert("Error", message: "Your passwords do not match")
            self.createAccountButtonPressed = false
            return
        }
        if inputPassword.characters.count < 6 || inputUsername.characters.count < 6 {
            self.sendAlert("Error", message: "Username and Password much be at least 6 characters in length")
            self.createAccountButtonPressed = false
            return
        }
        if inputUsername.characters.count > 20 || inputPassword.characters.count > 20 {
            self.sendAlert("Error", message: "Username and passwor may not exceed 20 characters in length")
            self.createAccountButtonPressed = false
            return
        }
        
        let encUsername = self.MyCryptoMachine.encryptStringToBase64(inputUsername)
        let encPassword = self.MyCryptoMachine.encryptStringToBase64(inputPassword)
        
        let myUrl = NSURL(string: "http://nickpitoniak.com/gone/checkForExistingUser.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "secretKey=kjdfb4u7bksSDDF44wlksdnw33j4&username=\(encUsername)"
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
                        if responseString as! String == "Invalid input" {
                            self.sendAlert("Error", message: "Input was invalid. Please try again later")
                            self.createAccountButtonPressed = false
                            return
                        }
                        if responseString as! String == "error" {
                            self.sendAlert("Error", message: "Something went wrong creating your account. Please try again later")
                            self.createAccountButtonPressed = false
                            return
                        }
                        if responseString as! String != "vacant" {
                            self.sendAlert("Error", message: "The username you entered is already in use. Please choose another one")
                            self.createAccountButtonPressed = false
                            return
                        } else {
                            let myUrl = NSURL(string: "http://nickpitoniak.com/gone/createUser.php?secretKey=kjdfb4u7bksSDDF44wlksdnw33j4&username=\(encUsername)&password=\(encPassword)")
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
                                            if responseString as! String == "Invalid input" {
                                                self.sendAlert("Error", message: "Input invalid. Please try again later")
                                                self.createAccountButtonPressed = false
                                                return
                                            }
                                            if responseString as! String == "error" {
                                                self.sendAlert("Error", message: "Something went wrong creating your account. Please try again later")
                                                self.createAccountButtonPressed = false
                                                return
                                            }
                                            if responseString != "success" {
                                                self.sendAlert("Error", message: "Unable to create your account")
                                                self.createAccountButtonPressed = false
                                                return
                                            } else {
                                                self.chooseUsername.text = ""
                                                self.choosePassword.text = ""
                                                self.choosePasswordTwo.text = ""
                                                self.sendAlert("Success", message: "You account has been created successfuly. Visit the login page to log into your account")
                                                self.createAccountButtonPressed = false
                                            }
                                        } // end createUser.php main dispatch
                                    } // check for data
                                } // end createUser.php time dipatch
                            } // end NSURLSession instantiation
                            task.resume()
                        } // end check for data
                    } // idk
                } // idk
            } // idk
        } // idk
        task.resume()
    } // end @IBAction creatAccountButton
    
    func dismissKeyboard() {
        self.chooseUsername.resignFirstResponder()
        self.choosePassword.resignFirstResponder()
        self.choosePasswordTwo.resignFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if textFieldMoved == false {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                if keyboardIsShowing == false {
                    self.keyboardHeight = Int(keyboardSize.height)
                    self.view.frame.origin.y -= keyboardSize.height
                    self.keyboardIsShowing = true
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
            textFieldMoved = false
        }
    }
    
    func logout() {
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "id")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "password")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func sendAlert(subject: String, message: String) {
        let alertController = UIAlertController(title: subject, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendAlert("Error", message: "You are not conn to the internet")
        self.welcomeLabel.text = "Account creation is anonymous"
        if Reachability.isConnectedToNetwork() != true {
            self.sendAlert("Error", message: "You are not connected to the internet")
            return
        }
        // keyboard initializations
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender senderObj: AnyObject?) {
        if(segue.identifier == "toLogin") {
            let theVC: ViewController = segue.destinationViewController as! ViewController
            theVC.shouldLogin = false
        }
    }
}
