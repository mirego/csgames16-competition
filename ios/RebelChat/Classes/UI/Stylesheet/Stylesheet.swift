//
//  Stylesheet.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-07.
//  Copyright © 2016 Mirego. All rights reserved.
//

import MRGArchitect

// PMARK: Values
class Stylesheet
{
    // PMARK: Constants
    static let architect = MRGArchitect(forClassName: "Stylesheet")
    
    // PMARK: Dimensions
    static let sideMargin: CGFloat = 20
    
    static var homeTopMargin: CGFloat { return architect.floatForKey("homeTopMargin") }
    static var homeBottomMargin: CGFloat { return architect.floatForKey("homeBottomMargin") }
    
    static var homeControlFontSize: CGFloat { return architect.floatForKey("homeControlFontSize") }
    static var homeControlHeight: CGFloat { return architect.floatForKey("homeControlHeight") }
    static var homeControlMargin: CGFloat { return architect.floatForKey("homeControlMargin") }
    
    static let snapButtonSize: CGFloat = 72
    static let toolsButtonSize: CGFloat = 56
    static let messageLabelHeight: CGFloat = 36
    
    // PMARK: Durations
    static let shortAnimationDuration: NSTimeInterval = 0.3
    static let mediumAnimationDuration: NSTimeInterval = 0.5
    static let longAnimationDuration: NSTimeInterval = 0.7
    static let progressAnimationDuration: NSTimeInterval = 1.5
    
    static let minimumLoadingDuration: NSTimeInterval = 0.5
    
    // PMARK: Image Names
    static var backgroundImageName: String { return architect.stringForKey("backgroundImageName") }
}

// PMARK: Colors
extension UIColor
{
    class func csPrimaryColor() -> UIColor
    {
        return UIColor(forHex: "db0c0d")
    }
    
    class func csGrayColor() -> UIColor
    {
        return UIColor(forHex: "4a4644")
    }
}

// PMARK: Fonts
extension UIFont
{
    // PMARK: Constants
    struct UIFontStylesheet
    {
        // Cache
        static let Cache = NSCache()
        
        // Font Names
        static let Flipbash = "Flipbash"
    }
    
    // PMARK: Custom Fonts
    class func csFontOfSize(size: CGFloat) -> UIFont
    {
        return customFont(UIFontStylesheet.Flipbash, size: size)
    }
    
    // PMARK: Font Helpers
    class func customFont(name: String, size: CGFloat) -> UIFont
    {
        return customFont(name, size: size, cacheKey: "#\(name):\(size)")
    }
    
    class func customFont(name: String, size: CGFloat, cacheKey: AnyObject) -> UIFont
    {
        if let font = UIFontStylesheet.Cache.objectForKey(cacheKey) as? UIFont
        {
            return font
        }
        
        let font = UIFont(name: name, size: size)!
        
        UIFontStylesheet.Cache.setObject(font, forKey: cacheKey)
        
        return font
    }
}
