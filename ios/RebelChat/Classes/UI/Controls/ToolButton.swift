//
//  ToolButton.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-08.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

class ToolButton: UIControl
{
    enum Tool
    {
        case Box
        case Cancel
        case Logout
        case Pencil
        case Photos
        case Shuffle
        case Text
    }
    
    private let imageView = UIImageView()
    
    init(tool: Tool)
    {
        super.init(frame: CGRectZero)
        
        switch (tool)
        {
        case .Box:
            imageView.image = UIImage(named: "icn-box")
        case .Cancel:
            imageView.image = UIImage(named: "icn-cancel")
        case .Logout:
            imageView.image = UIImage(named: "icn-logout")
        case .Pencil:
            imageView.image = UIImage(named: "icn-pencil")
        case .Photos:
            imageView.image = UIImage(named: "icn-photos")
        case .Shuffle:
            imageView.image = UIImage(named: "icn-shuffle")
        case .Text:
            imageView.image = UIImage(named: "icn-text")
        }
        
        imageView.contentMode = .Center
        imageView.sizeToFit()
        addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        imageView.mc_setPosition(.PositionCenters)
    }
}

// PMARK: Touch Events
extension ToolButton
{
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesBegan(touches, withEvent: event)
        
        UIView.animateWithDuration(Stylesheet.shortAnimationDuration, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: { () -> Void in
            self.imageView.transform = CGAffineTransformMakeScale(1.25, 1.25)
        }, completion: nil)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesEnded(touches, withEvent: event)
        
        UIView.animateWithDuration(Stylesheet.shortAnimationDuration * 0.65, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.imageView.transform = CGAffineTransformMakeScale(1.00, 1.00)
        }, completion: nil)
    }
}
