import Foundation
import CryptoSwift

class CryptoMachine {
    
    let key: [UInt8] = [0x23,0x021,0x18,0x39,0x32,0x19,0x11,0x43,0x19,0x38,0x21,0x021,0x33,0x014,0x038,0x022]
    let iv: [UInt8] = [0x54,0x29,0x12,0x13,0x34,0x29,0x22,0x14,0x16,0x12,0x14,0x33,0x42,0x32,0x19,0x32]
    
    let keyTwo: [UInt8] = [0x22,0x036,0x85,0x67,0x92,0x06,0x23,0x33,0x29,0x62,0x77,0x037,0x27,0x85,0x66,0x023]
    let ivTwo: [UInt8] = [0x55,0x25,0x98,0x16,0x67,0x43,0x86,0x48,0x54,0x66,0x18,0x66,0x26,0x42,0x50,0x18]
    
    let keyThree: [UInt8] = [0x44,0x047,0x75,0x86,0x84,0x85,0x89,0x86,0x83,0x44,0x56,0x72,0x48,0x029,0x92,0x21]
    let ivThree: [UInt8] = [0x45,0x26,0x83,0x68,0x82,0x65,0x99,0x47,0x56,0x83,0x44,0x38,0x47,0x84,0x33,0x34]
    
    let keyFour: [UInt8] = [0x35,0x021,0x18,0x39,0x32,0x55,0x96,0x44,0x76,0x85,0x59,0x87,0x54,0x86,0x77,0x95]
    let ivFour: [UInt8] = [0x55,0x24,0x44,0x86,0x49,0x62,0x55,0x58,0x56,0x66,0x87,0x48,0x63,0x22,0x54,0x32]
    
    
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
    
    func encryptStringToBase64(stringToEncrypt: String) -> String {
        do {
            let input: [UInt8] = Array(stringToEncrypt.utf8)
            let encryptedBytes: [UInt8] = try AES(key: key, iv: iv, blockMode: .CBC).encrypt(input, padding: PKCS7())
            let base64StringOne = String(byteArrayToBase64(encryptedBytes))
            
            let inputTwo: [UInt8] = Array(base64StringOne.utf8)
            let encryptedBytesTwo: [UInt8] = try AES(key: keyTwo, iv: ivTwo, blockMode: .CBC).encrypt(inputTwo, padding: PKCS7())
            let base64StringTwo = String(byteArrayToBase64(encryptedBytesTwo))
            
            let inputThree: [UInt8] = Array(base64StringTwo.utf8)
            let encryptedBytesThree: [UInt8] = try AES(key: keyThree, iv: ivThree, blockMode: .CBC).encrypt(inputThree, padding: PKCS7())
            let base64StringThree = String(byteArrayToBase64(encryptedBytesThree))
            
            let inputFour: [UInt8] = Array(base64StringThree.utf8)
            let encryptedBytesFour: [UInt8] = try AES(key: keyFour, iv: ivFour, blockMode: .CBC).encrypt(inputFour, padding: PKCS7())
            let base64StringFive = String(byteArrayToBase64(encryptedBytesFour))
            
            let noPlus = base64StringFive.stringByReplacingOccurrencesOfString("+", withString: "4756j389204547473wFF746463S5322", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let noEquals = noPlus.stringByReplacingOccurrencesOfString("=", withString: "645smbdDDDD3u3jbd288273642922bZ", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let finalString = noEquals.stringByReplacingOccurrencesOfString("/", withString: "3937bfuw827DD397282u3jjS334DDDY", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            
            return finalString
        } catch {
            return "fuck"
        }
    }
    
    func decryptBase64ToString(stringToDecrypt: String) -> String {
        do {
            
            let addPlus = stringToDecrypt.stringByReplacingOccurrencesOfString("4756j389204547473wFF746463S5322", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let addEquals = addPlus.stringByReplacingOccurrencesOfString("645smbdDDDD3u3jbd288273642922bZ", withString: "=", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let addedCharacters = addEquals.stringByReplacingOccurrencesOfString("3937bfuw827DD397282u3jjS334DDDY", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            let bytes = base64ToByteArray(addedCharacters)
            let decrypted: [UInt8] = try AES(key: keyFour, iv: ivFour, blockMode: .CBC).decrypt(bytes!, padding: PKCS7())
            let data = NSData(bytes: decrypted, length: decrypted.count)
            let decryptedString = String(data: data, encoding: NSUTF8StringEncoding)
            
            let bytesTwo = base64ToByteArray(decryptedString!)
            let decryptedTwo: [UInt8] = try AES(key: keyThree, iv: ivThree, blockMode: .CBC).decrypt(bytesTwo!, padding: PKCS7())
            let dataTwo = NSData(bytes: decryptedTwo, length: decryptedTwo.count)
            let decryptedStringTwo = String(data: dataTwo, encoding: NSUTF8StringEncoding)
            
            let bytesThree = base64ToByteArray(decryptedStringTwo!)
            let decryptedThree: [UInt8] = try AES(key: keyTwo, iv: ivTwo, blockMode: .CBC).decrypt(bytesThree!, padding: PKCS7())
            let dataThree = NSData(bytes: decryptedThree, length: decryptedThree.count)
            let decryptedStringThree = String(data: dataThree, encoding: NSUTF8StringEncoding)
            
            let bytesFour = base64ToByteArray(decryptedStringThree!)
            let decryptedFour: [UInt8] = try AES(key: key, iv: iv, blockMode: .CBC).decrypt(bytesFour!, padding: PKCS7())
            let dataFour = NSData(bytes: decryptedFour, length: decryptedFour.count)
            let decryptedStringFour = String(data: dataFour, encoding: NSUTF8StringEncoding)
            
            
            
            return decryptedStringFour!
        } catch {
            return "fuck"
        }
    }
    
    /*
    let key: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
    let iv: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
    
    let keyTwo: [UInt8] = [0x22,0x036,0x85,0x67,0x92,0x06,0x23,0x33,0x29,0x62,0x77,0x037,0x27,0x85,0x66,0x023]
    let ivTwo: [UInt8] = [0x55,0x25,0x98,0x16,0x67,0x43,0x86,0x48,0x54,0x66,0x18,0x66,0x26,0x42,0x50,0x18]
    
    let keyThree: [UInt8] = [0x44,0x047,0x75,0x86,0x84,0x85,0x89,0x86,0x83,0x44,0x56,0x72,0x48,0x029,0x92,0x21]
    let ivThree: [UInt8] = [0x45,0x26,0x83,0x68,0x82,0x65,0x99,0x47,0x56,0x83,0x44,0x38,0x47,0x84,0x33,0x34]
    
    let keyFour: [UInt8] = [0x35,0x021,0x18,0x39,0x32,0x55,0x96,0x44,0x76,0x85,0x59,0x87,0x54,0x86,0x77,0x95]
    let ivFour: [UInt8] = [0x55,0x24,0x44,0x86,0x49,0x62,0x55,0x58,0x56,0x66,0x87,0x48,0x63,0x22,0x54,0x32]*/
    
    
    /*
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
*/
}



