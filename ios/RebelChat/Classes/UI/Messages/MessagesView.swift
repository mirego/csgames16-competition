//
//  MessagesView.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-08.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

protocol MessagesViewDelegate
{
    func didTapLogoutButton()
    func didTapShuffleButton()
    func didTapSnapButton(text text: String, imageFromView: UIView)
}

class MessagesView: UIView
{
    private let canvasView = UIView()
    private let messageImageView = UIImageView()
    private let messageTextLabel = UILabel()
    
    private let logoutButton = ToolButton(tool: .Logout)
    private let shuffleButton = ToolButton(tool: .Shuffle)
    
    private let snapButton = SnapButton()
    
    var delegate: MessagesViewDelegate?
    
    init()
    {
        super.init(frame: CGRectZero)
        
        addSubview(canvasView)
        
        messageImageView.contentMode = .ScaleAspectFill
        canvasView.addSubview(messageImageView)
        
        messageTextLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
        messageTextLabel.font = UIFont.csFontOfSize(14)
        messageTextLabel.textAlignment = .Center
        messageTextLabel.textColor = UIColor.whiteColor()
        canvasView.addSubview(messageTextLabel)
        
        logoutButton.addTarget(self, action: "didTapLogoutButton", forControlEvents: .TouchUpInside)
        addSubview(logoutButton)
        
        shuffleButton.addTarget(self, action: "didTapShuffleButton", forControlEvents: .TouchUpInside)
        addSubview(shuffleButton)
        
        snapButton.addTarget(self, action: "didTapSnapButton", forControlEvents: .TouchUpInside)
        addSubview(snapButton)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        canvasView.frame = bounds
        messageImageView.frame = canvasView.bounds
        
        messageTextLabel.mc_setPosition(.PositionCenters, withMargins: UIEdgeInsetsZero, size: CGSize(width: mc_width(), height: Stylesheet.messageLabelHeight))
        
        let toolsButtonSize = CGSize(width: Stylesheet.toolsButtonSize, height: Stylesheet.toolsButtonSize)
        logoutButton.mc_setPosition(.PositionTopLeft, withMargins: UIEdgeInsetsZero, size: toolsButtonSize)
        shuffleButton.mc_setPosition(.PositionTopRight, withMargins: UIEdgeInsetsZero, size: toolsButtonSize)
        
        snapButton.mc_setPosition(.PositionBottomHCenter, withMargins: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0), size: CGSize(width: Stylesheet.snapButtonSize, height: Stylesheet.snapButtonSize))
    }
    
    func configure(text text: String, image: UIImage?)
    {
        messageTextLabel.text = text
        messageImageView.image = image
    }
}

// PMARK: Control Events
extension MessagesView
{
    func didTapLogoutButton()
    {
        delegate?.didTapLogoutButton()
    }
    
    func didTapShuffleButton()
    {
        delegate?.didTapShuffleButton()
    }
    
    func didTapSnapButton()
    {
        delegate?.didTapSnapButton(text: messageTextLabel.text ?? "", imageFromView: canvasView)
    }
}
