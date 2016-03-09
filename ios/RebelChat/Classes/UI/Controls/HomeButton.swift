//
//  HomeButton.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-07.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

class HomeButton: UIControl
{
    enum Style
    {
        case Accept
        case Cancel
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title.uppercaseString
            setNeedsLayout()
        }
    }
    
    var style: Style = .Accept {
        didSet {
            updateColors()
            refreshColors()
        }
    }
    
    override var highlighted: Bool {
        didSet {
            refreshColors()
        }
    }
    
    private let titleLabel = UILabel()
    
    private var normalBackgroundColor: UIColor = UIColor.clearColor()
    private var highlightedBackgroundColor: UIColor = UIColor.clearColor()
    
    init()
    {
        super.init(frame: CGRectZero)
        
        titleLabel.font = UIFont.csFontOfSize(Stylesheet.homeControlFontSize)
        addSubview(titleLabel)
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        titleLabel.mc_setPosition(.PositionCenters, withMargins: UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0))
    }
}

// PMARK: Private
extension HomeButton
{
    private func updateColors()
    {
        switch (style)
        {
        case .Accept:
            normalBackgroundColor = UIColor.csPrimaryColor()
        case .Cancel:
            normalBackgroundColor = UIColor.csGrayColor()
        }
        highlightedBackgroundColor = normalBackgroundColor.colorWithMultiplier(1.2)
    }
    
    private func refreshColors()
    {
        backgroundColor = highlighted ? highlightedBackgroundColor : normalBackgroundColor
        titleLabel.textColor = UIColor.whiteColor()
    }
}
