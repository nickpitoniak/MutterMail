
import UIKit

class chatPlatformAbout: UIViewController {
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    
    
    override func viewDidLoad() {
        self.labelOne.text = "1. Decryption input\nDecipher encrypted messages sent by your chat partner. The decryption key must be identical to the encryption key used be your partner."
        self.labelTwo.text = "2. Encryption input\nEncrypt a message. Your partner must enter the identical term to read the message."
        self.labelThree.text = "3. Message input\nEnter a string of text to be sent to your chat partner. If the encryption input is blank the message will be sent in plain text."
    }

}