//
//  cryptoMacine.swift
//  collaboration
//
//  Created by nick on 12/29/15.
//  Copyright © 2015 Supreme Leader. All rights reserved.
//
/*
import Foundation
import CryptoSwift

class CryptoMachine {
    
    /*let key: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
    let iv: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
    
    let keyTwo: [UInt8] = [0x22,0x036,0x85,0x67,0x92,0x06,0x23,0x33,0x29,0x62,0x77,0x037,0x27,0x85,0x66,0x023]
    let ivTwo: [UInt8] = [0x55,0x25,0x98,0x16,0x67,0x43,0x86,0x48,0x54,0x66,0x18,0x66,0x26,0x42,0x50,0x18]
    
    let keyThree: [UInt8] = [0x44,0x047,0x75,0x86,0x84,0x85,0x89,0x86,0x83,0x44,0x56,0x72,0x48,0x029,0x92,0x21]
    let ivThree: [UInt8] = [0x45,0x26,0x83,0x68,0x82,0x65,0x99,0x47,0x56,0x83,0x44,0x38,0x47,0x84,0x33,0x34]
    
    let keyFour: [UInt8] = [0x35,0x021,0x18,0x39,0x32,0x55,0x96,0x44,0x76,0x85,0x59,0x87,0x54,0x86,0x77,0x95]
    let ivFour: [UInt8] = [0x55,0x24,0x44,0x86,0x49,0x62,0x55,0x58,0x56,0x66,0x87,0x48,0x63,0x22,0x54,0x32]*/
    
    
    let key: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
    let iv: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
    
    func byteArrayToBase64(bytes: [UInt8]) -> String {
        let nsdata = NSData(bytes: bytes, length: bytes.count)
        let base64Encoded = nsdata.base64EncodedStringWithOptions([]);
        return base64Encoded;
    }
    
    func base64ToByteArray(base64String: String) -> [UInt8]? {
        if let nsdata = NSData(base64EncodedString: base64String, options: []) {
            var bytes = [UInt8](count: nsdata.length, repeatedValue: 0)
            nsdata.getBytes(&bytes, length: bytes.count)
            return bytes
        }
        return nil
    }
    
    func encryptStringToBase64(str: String) -> String {
        do {
            let input: [UInt8] = Array(str.utf8)
            let encrypted: [UInt8] = try AES(key: key, iv: iv, blockMode: .CBC).encrypt(input, padding: PKCS7())
            let base64String = byteArrayToBase64(encrypted) as String
            let noPlus = base64String.stringByReplacingOccurrencesOfString("+", withString: "4756j389204547473wFF746463S5322", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let noEquals = noPlus.stringByReplacingOccurrencesOfString("=", withString: "645smbdDDDD3u3jbd288273642922bZ", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let finalString = noEquals.stringByReplacingOccurrencesOfString("/", withString: "3937bfuw827DD397282u3jjS334DDDY", options: NSStringCompareOptions.LiteralSearch, range: nil)
            return finalString
        } catch {
            return "fuck"
        }
    }
    
    func decryptBase64ToString(str: String) -> String {
        do {
            let addPlus = str.stringByReplacingOccurrencesOfString("4756j389204547473wFF746463S5322", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let addEquals = addPlus.stringByReplacingOccurrencesOfString("645smbdDDDD3u3jbd288273642922bZ", withString: "=", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let addedCharacters = addEquals.stringByReplacingOccurrencesOfString("3937bfuw827DD397282u3jjS334DDDY", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            let bytes = base64ToByteArray(addedCharacters)
            let decrypted: [UInt8] = try AES(key: key, iv: iv, blockMode: .CBC).decrypt(bytes!, padding: PKCS7())
            let dataFour = NSData(bytes: decrypted, length: decrypted.count)
            let string = String(data: dataFour, encoding: NSUTF8StringEncoding)
            return string!
        } catch {
            return "fuck"
        }
    }
    
}
*/