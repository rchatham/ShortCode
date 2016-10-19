//
//  ShortCodeGenerator.swift
//  ShortCode
//
//  Created by Reid Chatham on 3/15/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

/**
 Struct consisting entirely of static stateless contructors for generating unique short codes.
 */
public struct ShortCodeGenerator {
    
    public static let base62chars = [Character]("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".characters)
    private static let maxBase : UInt32 = 62
    
    
    public static func getCode(withBase base: UInt32 = maxBase, length: Int) -> String {
        var code = ""
        let base = min(base, maxBase)
        for _ in 0..<length {
            let random = Int(arc4random_uniform(base))
            code.append(base62chars[random])
        }
        return code
    }
    
    public static func getCode(withBase base: UInt32 = maxBase, length: Int, uniquenessCheck: (String->Bool) = {_ in true}, retryLimit limit: Int? = nil) -> String? {
        
        guard limit != nil ? limit! > 0 : true else { return nil }
        
        var code = ""
        let base = min(base, maxBase)
        for _ in 0..<length {
            let random = Int(arc4random_uniform(base))
            code.append(base62chars[random])
        }
        
        if !uniquenessCheck(code) {
            return getCode(withBase: base, length: length, uniquenessCheck: uniquenessCheck, retryLimit: limit != nil ? limit!-1 : nil)
        }
        return code
    }
    
    public static func convertIntToBase62(integer: Int) -> String {
        var code = ""
        var currentInt = integer
        
        repeat {
            let i = currentInt % 62
            code = "\(base62chars[i])" + code
            currentInt /= 62
        } while currentInt > 0
        
        return code
    }
    
    public static func convertInt(integer: Int, toBase base: Int) -> String {
        var code = ""
        var currentInt = integer
        let base = min(base, Int(maxBase))
        
        repeat {
            let i = currentInt % base
            code = "\(base62chars[i])" + code
            currentInt /= base
        } while currentInt > 0
        
        return code
    }
    
    public static func convertDateToBase62(date: NSDate) -> String {
        let timeIntervalSinceReferenceDate = date.timeIntervalSinceReferenceDate
        let milliseconds = Int(timeIntervalSinceReferenceDate * 1000)
        
        return convertIntToBase62(milliseconds)
    }
    
    public static func convertCodeToInt(code: String, withBase base: Int) -> Int {
        
        var code = [Character](code.characters)
        var int = 0
        
        let last = code.removeLast()
        int += (base62chars.indexOf(last)!)
        
        var i = base
        repeat {
            let last = code.removeLast()
            int += ((base62chars.indexOf(last)!) * i)
            i *= base
        } while !code.isEmpty
        
        return int
    }
    
    public static func convertBase62toInt(code: String) -> Int {
        
        var code = [Character](code.characters)
        var int = 0
        
        let last = code.removeLast()
        int += (base62chars.indexOf(last)!)
        
        var i = 62
        repeat {
            let last = code.removeLast()
            int += ((base62chars.indexOf(last)!) * i)
            i *= 62
        } while !code.isEmpty
        
        return int
    }
    
    public static func convertBase62Date(code: String) -> NSDate {
        let int = convertBase62toInt(code)
        return NSDate(timeIntervalSinceReferenceDate: Double(int)/1000)
    }
    
    public static func convertCode(code: String, withBase base1: Int, toCodeWithBase base2: Int) -> String {
        let integer = convertCodeToInt(code, withBase: base1)
        return convertInt(integer, toBase: base2)
    }
}

