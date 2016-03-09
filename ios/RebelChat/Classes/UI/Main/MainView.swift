//
//  MainView.swift
//  RebelChat
//
//  Created by Hugo Lefrancois on 2016-02-20.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

protocol MainViewDelegate
{
    func didSubmitLogin(username username: String, password: String)
    func didSubmitRegister(username username: String, password: String, email: String)
}

class MainView: UIView
{
    enum State
    {
        case MainMenu
        case Login
        case Register
    }
    
    private(set) var state: State = .MainMenu
    
    private let backgroundImageView = UIImageView(image: UIImage(named: Stylesheet.backgroundImageName))
    
    private let logoImageView = UIImageView(image: UIImage(named: "img-logo"))
    private let titleImageView = UIImageView(image: UIImage(named: "img-title"))
    
    private let controlsView = UIView()
    private let mainMenuControlsView = MainMenuControlsView()
    private let userControlsView = UserControlsView()
    
    private var topPadding: CGFloat = 0
    private var bottomPadding: CGFloat = 0
    
    var delegate: MainViewDelegate?
    
    init()
    {
        super.init(frame: CGRect.zero)

        addSubview(backgroundImageView)
        
        addSubview(logoImageView)
        addSubview(titleImageView)
        
        addSubview(controlsView)
        
        mainMenuControlsView.delegate = self
        controlsView.addSubview(mainMenuControlsView)
        
        userControlsView.delegate = self
        controlsView.addSubview(userControlsView)
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        // Set the background in place
        backgroundImageView.frame = bounds
        
        // Resize the subviews
        [logoImageView, titleImageView].forEach { $0.sizeToFit() }
        [mainMenuControlsView, userControlsView].forEach { $0.mc_setSize($0.sizeThatFits(mc_size())) }
        
        controlsView.mc_setSize(CGSize(width: mc_width(), height: max(mainMenuControlsView.mc_height(), userControlsView.mc_height())))
        
        // Position the subviews
        positionSections()
        positionControlsViews()
    }
    
    func positionSections()
    {
        // Adapt the layout when the keyboard is shown or hidden
        let shouldOffsetViews = (bottomPadding > 0)
        
        [logoImageView, titleImageView].forEach { $0.alpha = (shouldOffsetViews ? 0 : 1) }
        
        if (!shouldOffsetViews)
        {
            logoImageView.mc_setPosition(.PositionTopHCenter, withMargins: UIEdgeInsets(top: topPadding + Stylesheet.homeTopMargin, left: 0, bottom: 0, right: 0))
            titleImageView.mc_setRelativePosition(.RelativePositionUnderCentered, toView: logoImageView, withMargins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
            
            controlsView.mc_setPosition(.PositionBottomHCenter, withMargins: UIEdgeInsets(top: 0, left: 0, bottom: Stylesheet.homeBottomMargin, right: 0))
        }
        else
        {
            logoImageView.mc_setPosition(.PositionTopHCenter)
            titleImageView.mc_setPosition(.PositionTopHCenter, withMargins: UIEdgeInsets(top: logoImageView.mc_height() * 0.75, left: 0, bottom: 0, right: 0))
            
            controlsView.mc_setPosition(.PositionTopHCenter, withMargins: UIEdgeInsets(top: topPadding + (mc_height() - topPadding - bottomPadding - controlsView.mc_height()) / 2, left: 0, bottom: 0, right: 0))
        }
    }
    
    func positionControlsViews()
    {
        // Show either the Main Menu or the Login / Register forms
        if (state == .MainMenu) {
            mainMenuControlsView.mc_setPosition(.PositionCenters, withMargins: UIEdgeInsetsZero)
            userControlsView.mc_setPosition(.PositionCenters, withMargins: UIEdgeInsets(top: 0, left: mc_width(), bottom: 0, right: 0))
        } else {
            mainMenuControlsView.mc_setPosition(.PositionCenters, withMargins: UIEdgeInsets(top: 0, left: -mc_width(), bottom: 0, right: 0))
            userControlsView.mc_setPosition(.PositionCenters, withMargins: UIEdgeInsetsZero)
        }
    }
}

// PMARK: Public
extension MainView
{
    // The top padding comes from the Status Bar and will help centering the views
    func setTopPadding(topPadding: CGFloat, animationDuration: NSTimeInterval = 0, repositionSections: Bool = true)
    {
        self.topPadding = topPadding
        
        if (repositionSections)
        {
            UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                self.positionSections()
            }, completion: nil)
        }
    }
    
    // The bottom padding comes from the Software Keyboard, when it is shown, and will reposition the view sections
    func setBottomPadding(bottomPadding: CGFloat, animationDuration: NSTimeInterval = 0, repositionSections: Bool = true)
    {
        self.bottomPadding = bottomPadding
        
        if (repositionSections)
        {
            UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                self.positionSections()
            }, completion: nil)
        }
    }
}

// PMARK: Private
extension MainView
{
    func setState(state: State, animated: Bool)
    {
        self.state = state
        
        switch (state)
        {
        case .Login:
            userControlsView.type = .Login
        case .Register:
            userControlsView.type = .Register
        default:
            break
        }
        
        let startView = (state == .MainMenu) ? userControlsView : mainMenuControlsView
        let endView = (state == .MainMenu) ? mainMenuControlsView : userControlsView
        
        let shouldFocusOnTextField = (endView == self.userControlsView)
        
        if (animated)
        {
            // Animate to the next controls view with a spring animation
            UIView.animateWithDuration(Stylesheet.mediumAnimationDuration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.positionControlsViews()
            }, completion: { (finished) -> Void in
                self.userControlsView.focusOnTextField(shouldFocusOnTextField)
            })
        
            // Slightly offset each control during the animation
            [startView.subviews, endView.subviews].flatMap({ $0 }).forEach { (view) -> () in
                let originalCenter = view.center
                let modifiedCenter = CGPoint(x: view.center.x + random(0...10) * (view.superview == mainMenuControlsView ? -1 : 1), y: view.center.y)
                
                view.center = (view.superview == startView) ? originalCenter : modifiedCenter
                
                UIView.animateWithDuration(Stylesheet.mediumAnimationDuration, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    view.center = (view.superview == endView) ? originalCenter : modifiedCenter
                }, completion: { (finished) -> Void in
                    view.center = originalCenter
                })
            }
        }
        else
        {
            positionControlsViews()
            userControlsView.focusOnTextField(shouldFocusOnTextField)
        }
    }
}

// PMARK: MainMenuControlsViewDelegate
extension MainView: MainMenuControlsViewDelegate
{
    func didTapLoginButton()
    {
        setState(.Login, animated: true)
    }
    
    func didTapRegisterButton()
    {
        setState(.Register, animated: true)
    }
}

// PMARK: UserControlsViewDelegate, RegisterControlsViewDelegate
extension MainView: UserControlsViewDelegate
{
    func didSubmitLogin(username username: String, password: String)
    {
        delegate?.didSubmitLogin(username: username, password: password)
    }
    
    func didSubmitRegister(username username: String, password: String, email: String)
    {
        delegate?.didSubmitRegister(username: username, password: password, email: email)
    }
    
    func didTapBackButton()
    {
        setState(.MainMenu, animated: true)
    }
}
