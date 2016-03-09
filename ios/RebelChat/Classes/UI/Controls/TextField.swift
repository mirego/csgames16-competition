//
//  TextField.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-07.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

class TextField: UITextField
{
    init()
    {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor.whiteColor()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect
    {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect
    {
        return CGRectInset(bounds, 10, 10)
    }
}
