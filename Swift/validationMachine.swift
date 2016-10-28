//
//  validationMachine.swift
//  collaboration
//
//  Created by nick on 12/4/15.
//  Copyright © 2015 Supreme Leader. All rights reserved.
//

import Foundation

class ValidationMachine {
    var alphaNumerals = [
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
    var acceptableCharacters = [
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
        ".",
        "'",
        "!",
        "@",
        "#",
        "$",
        "%",
        "^",
        "&",
        "*",
        "(",
        ")",
        "-",
        "_",
        "+",
        "=",
        "?",
        ",",
        ".",
        "/"
    ]
    func isAlphaNumeric(inputString: String) -> Bool {
        let characters = Array(inputString.characters)
        for character in characters {
            let stringChar = String(character)
            var match = false
            for alphaChar in alphaNumerals {
                print(alphaChar)
                if stringChar.lowercaseString == alphaChar.lowercaseString {
                    print("MATCH")
                    match = true
                }
            }
            if match == false {
                return false
            }
        }
        return true
    }
    func testMethod(inputString: String) -> Bool {
        if inputString.characters.count > 5 {
            return true
        } else {
            return false
        }
    }
    func allAcceptableCharacters(inputString: String) -> Bool {
        let characters = Array(inputString.characters)
        for character in characters {
            let stringChar = String(character)
            var match = false
            for alphaChar in acceptableCharacters {
                if stringChar.lowercaseString == alphaChar.lowercaseString {
                    match = true
                }
            }
            if match == false {
                return false
            }
        }
        return true
    }
}