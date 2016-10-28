
import Foundation

class FunctionMachine {
    var alphabetArray = [
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
        " "
    ]
    var messageAlphabetArray = [
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
        " ",
        ";",
        "#",
        "+",
        "=",
        "/",
        "!",
        ".",
        "?",
        ":",
        "(",
        ")",
        ","
    ]
    func basicAcceptableCharacters(inputString: String) -> Bool {
        let characters = Array(inputString.characters)
        for character in characters {
            var match = false
            let convertedString = String(character)
            for letter in alphabetArray {
                if letter.lowercaseString == convertedString.lowercaseString {
                    match = true
                }
            }
            if match == false {
                return true
            }
        }
        return false
    }
    func basicAcceptableMessageCharacters(inputString: String) -> Bool {
        let characters = Array(inputString.characters)
        for character in characters {
            var match = false
            let convertedString = String(character)
            for letter in messageAlphabetArray {
                if letter.lowercaseString == convertedString.lowercaseString {
                    match = true
                }
            }
            if match == false {
                return true
            }
        }
        return false
    }
    func checkForLetters(str: String) -> Bool {
        let letters = NSCharacterSet.letterCharacterSet()
        let range = str.rangeOfCharacterFromSet(letters)
        if let _ = range {
            return true
        }
        return false
    }
    func getURLContents(url: String) -> String {
        let myUrl = NSURL(string: url)
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
                    return responseString as! String
                }
            }
        }
        task.resume()
        return "fuck"
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
            "(",
            ")"
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
    func testForInvalidCharacters(inputString: String) -> Bool {
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
            "9"
        ]
        let stringToVoidArray = Array(inputString.characters)
        for letter in stringToVoidArray {
            var isAcceptable = false
            for character in acceptableCharacters {
                if character as String == String(letter) {
                    isAcceptable = true
                }
            }
            if isAcceptable == false {
                return true
            }
        }
        return false
    }
}