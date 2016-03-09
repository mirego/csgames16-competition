//
//  MainMenuControlsView.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-07.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

protocol MainMenuControlsViewDelegate
{
    func didTapLoginButton()
    func didTapRegisterButton()
}

class MainMenuControlsView: UIView
{
    private let loginButton = HomeButton()
    private let registerButton = HomeButton()
    
    var delegate: MainMenuControlsViewDelegate?
    
    init()
    {
        super.init(frame: CGRectZero)
        
        loginButton.title = LocalizedString("LOGIN_BUTTON")
        loginButton.style = .Accept
        loginButton.addTarget(self, action: "didTapLoginButton", forControlEvents: .TouchUpInside)
        addSubview(loginButton)
        
        registerButton.title = LocalizedString("REGISTER_BUTTON")
        registerButton.style = .Cancel
        registerButton.addTarget(self, action: "didTapRegisterButton", forControlEvents: .TouchUpInside)
        addSubview(registerButton)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let controlWidth = mc_width() - Stylesheet.sideMargin * 2
        
        let topMargin = (mc_height() - contentHeight()) / 2
        
        loginButton.mc_setPosition(.PositionTopHCenter, withMargins: UIEdgeInsets(top: topMargin, left: 0, bottom: 0, right: 0), size: CGSize(width: controlWidth, height: Stylesheet.homeControlHeight))
        
        registerButton.mc_setRelativePosition(.RelativePositionUnderCentered, toView: loginButton, withMargins: UIEdgeInsets(top: Stylesheet.homeControlMargin, left: 0, bottom: 0, right: 0), size: CGSize(width: controlWidth, height: Stylesheet.homeControlHeight))
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize
    {
        return CGSize(width: size.width, height: contentHeight())
    }
    
    private func contentHeight() -> CGFloat
    {
        let controlCount = CGFloat([loginButton, registerButton].count)
        return Stylesheet.homeControlHeight * controlCount + Stylesheet.homeControlMargin * (controlCount - 1)
    }
}

// PMARK: Control Events
extension MainMenuControlsView
{
    func didTapLoginButton()
    {
        delegate?.didTapLoginButton()
    }
    
    func didTapRegisterButton()
    {
        delegate?.didTapRegisterButton()
    }
}
