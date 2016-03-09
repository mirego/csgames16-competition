//
//  SnapButton.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-07.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

class SnapButton: UIControl
{
    let innerCircle = RadialGradientLayer()
    
    var touchStartDate: NSDate?
    var touchTimer: NSTimer?
    
    init()
    {
        super.init(frame: CGRectZero)
        
        clipsToBounds = true
        
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1
        
        innerCircle.borderColor = UIColor.whiteColor().CGColor
        innerCircle.borderWidth = 5
        
        layer.addSublayer(innerCircle)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        layer.cornerRadius = mc_width() * 0.5
        
        innerCircle.cornerRadius = layer.cornerRadius
        innerCircle.frame = layer.bounds
        
        refreshInnerCircle()
    }
    
    func refreshInnerCircle()
    {
        let progress = CGFloat(min(1, -(touchStartDate?.timeIntervalSinceNow ?? 0) / Stylesheet.progressAnimationDuration))
        
        let alphaProgress = easeOut(progress)
        let tintProgress = easeInOut(max(0, progress - 0.33) * 1.5)
        
        innerCircle.colors = [
            UIColor(hue: 0.0, saturation: 0.65 * tintProgress, brightness: 1.0, alpha: 0.5 - 0.5 * alphaProgress),
            UIColor(hue: 0.0, saturation: 0.65 * tintProgress, brightness: 1.0, alpha: 0.5 + 0.15 * alphaProgress)
        ]
        
        innerCircle.locations = [0, 0.85]
        innerCircle.setNeedsDisplay()
    }
}

// PMARK: Touch Events
extension SnapButton
{
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesBegan(touches, withEvent: event)
        
        startTimer()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesEnded(touches, withEvent: event)
        
        stopTimer()
    }
}

// PMARK: Private
extension SnapButton
{
    private func startTimer()
    {
        if (touchTimer == nil)
        {
            touchStartDate = NSDate()
            touchTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "refreshInnerCircle", userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer()
    {
        touchStartDate = nil
        
        touchTimer?.invalidate()
        touchTimer = nil
        
        refreshInnerCircle()
    }
}

class RadialGradientLayer: CALayer
{
    var colors: [UIColor] = []
    var locations: [CGFloat] = []
    
    override func drawInContext(ctx: CGContext)
    {
        let center = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
        let radius = bounds.width * 0.5
        
        CGContextSaveGState(ctx)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColors(colorSpace, colors.map { $0.CGColor }, locations)
        CGContextDrawRadialGradient(ctx, gradient, center, 0.0, center, radius, CGGradientDrawingOptions(rawValue: 0))
    }
    
}
