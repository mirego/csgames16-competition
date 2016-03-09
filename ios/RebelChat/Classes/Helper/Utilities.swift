//
//  Utilities.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-07.
//  Copyright © 2016 Mirego. All rights reserved.
//

import Foundation

func delay(delay: Double, closure: () -> ())
{
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), closure)
}

func random(range: Range<Int>) -> CGFloat
{
    let mini = UInt32(range.startIndex)
    let maxi = UInt32(range.endIndex)
    
    return CGFloat(mini + arc4random_uniform(maxi - mini))
}

func randomString(length: Int) -> String
{
    let letters = NSString(string: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    let totalLetters = UInt32(letters.length)
    
    let randomString = NSMutableString(capacity: length)
    
    for _ in 0...length
    {
        let rand = arc4random_uniform(totalLetters)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }
    
    return "\(randomString)"
}
