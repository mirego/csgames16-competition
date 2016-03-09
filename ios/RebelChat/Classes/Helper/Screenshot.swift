//
//  Screenshot.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-08.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

extension UIView
{
    func snapshot() -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0)
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIImage
{
    func toBase64String() -> String
    {
        let imageData = UIImagePNGRepresentation(self)
        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        return base64String
    }
    
    class func fromBase64String(base64String: String) -> UIImage?
    {
        let imageData = NSData(base64EncodedString: base64String, options: .IgnoreUnknownCharacters)
        let image = (imageData != nil ? UIImage(data: imageData!) : nil)
        
        return image
    }
}
