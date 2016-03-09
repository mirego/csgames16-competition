//
//  UserControlsView.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-07.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

protocol UserControlsViewDelegate
{
    func didSubmitLogin(username username: String, password: String)
    func didSubmitRegister(username username: String, password: String, email: String)
    func didTapBackButton()
}

class UserControlsView: UIView
{
    enum Type
    {
        case Login
        case Register
    }
    
    var type: Type = .Login {
        didSet {
            refresh()
        }
    }
    
    private let usernameTextField = TextField()
    private let passwordTextField = TextField()
    private let emailTextField = TextField()
    
    private let backButton = HomeButton()
    private let submitButton = HomeButton()
    
    var delegate: UserControlsViewDelegate?
    
    init()
    {
        super.init(frame: CGRectZero)
        
        usernameTextField.autocapitalizationType = .None
        usernameTextField.autocorrectionType = .No
        usernameTextField.delegate = self
        usernameTextField.font = UIFont.csFontOfSize(Stylesheet.homeControlFontSize)
        usernameTextField.placeholder = LocalizedString("USERNAME_PLACEHOLDER")
        usernameTextField.returnKeyType = .Next
        addSubview(usernameTextField)
        
        passwordTextField.autocapitalizationType = .None
        passwordTextField.autocorrectionType = .No
        passwordTextField.delegate = self
        passwordTextField.font = UIFont.csFontOfSize(Stylesheet.homeControlFontSize)
        passwordTextField.placeholder = LocalizedString("PASSWORD_PLACEHOLDER")
        passwordTextField.returnKeyType = .Next
        passwordTextField.secureTextEntry = true
        addSubview(passwordTextField)
        
        emailTextField.autocapitalizationType = .None
        emailTextField.autocorrectionType = .No
        emailTextField.delegate = self
        emailTextField.font = UIFont.csFontOfSize(Stylesheet.homeControlFontSize)
        emailTextField.keyboardType = .EmailAddress
        emailTextField.placeholder = LocalizedString("EMAIL_PLACEHOLDER")
        emailTextField.returnKeyType = .Go
        addSubview(emailTextField)
        
        backButton.title = LocalizedString("BACK_BUTTON")
        backButton.style = .Cancel
        backButton.addTarget(self, action: "didTapBackButton", forControlEvents: .TouchUpInside)
        addSubview(backButton)
        
        submitButton.title = LocalizedString("SUBMIT_BUTTON")
        submitButton.style = .Accept
        submitButton.addTarget(self, action: "didTapSubmitButton", forControlEvents: .TouchUpInside)
        addSubview(submitButton)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let fullControlWidth = mc_width() - Stylesheet.sideMargin * 2
        let halfControlWidth = (fullControlWidth - Stylesheet.homeControlMargin) / 2
        
        let topMargin = (mc_height() - contentHeight()) / 2
        
        usernameTextField.mc_setPosition(.PositionTopHCenter, withMargins: UIEdgeInsets(top: topMargin, left: 0, bottom: 0, right: 0), size: CGSize(width: fullControlWidth, height: Stylesheet.homeControlHeight))
        
        passwordTextField.mc_setRelativePosition(.RelativePositionUnderCentered, toView: usernameTextField, withMargins: UIEdgeInsets(top: Stylesheet.homeControlMargin, left: 0, bottom: 0, right: 0), size: CGSize(width: fullControlWidth, height: Stylesheet.homeControlHeight))
        
        emailTextField.hidden = type != .Register
        
        if (!emailTextField.hidden) {
            emailTextField.mc_setRelativePosition(.RelativePositionUnderCentered, toView: passwordTextField, withMargins: UIEdgeInsets(top: Stylesheet.homeControlMargin, left: 0, bottom: 0, right: 0), size: CGSize(width: fullControlWidth, height: Stylesheet.homeControlHeight))
        }
        
        let previousView = (emailTextField.hidden ? passwordTextField : emailTextField)
        
        backButton.mc_setRelativePosition(.RelativePositionUnderAlignedLeft, toView: previousView, withMargins: UIEdgeInsets(top: Stylesheet.homeControlMargin, left: 0, bottom: 0, right: 0), size: CGSize(width: halfControlWidth, height: Stylesheet.homeControlHeight))
        submitButton.mc_setRelativePosition(.RelativePositionUnderAlignedRight, toView: previousView, withMargins: UIEdgeInsets(top: Stylesheet.homeControlMargin, left: 0, bottom: 0, right: 0), size: CGSize(width: halfControlWidth, height: Stylesheet.homeControlHeight))
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize
    {
        return CGSize(width: size.width, height: contentHeight(true))
    }
    
    private func contentHeight(useLargest: Bool = false) -> CGFloat
    {
        let controlsCount = CGFloat((type == .Register || useLargest) ? 4 : 3)
        return Stylesheet.homeControlHeight * controlsCount + Stylesheet.homeControlMargin * (controlsCount - 1)
    }
}

// PMARK: Public
extension UserControlsView
{
    func refresh()
    {
        usernameTextField.text = ""
        passwordTextField.text = ""
        emailTextField.text = ""
        
        passwordTextField.returnKeyType = (type == .Login ? .Go : .Next)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func focusOnTextField(focus: Bool)
    {
        if (focus) {
            usernameTextField.becomeFirstResponder()
        } else {
            usernameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            emailTextField.resignFirstResponder()
        }
    }
}

// PMARK: Control Events
extension UserControlsView
{
    func didTapSubmitButton()
    {
        if (type == .Login) {
            delegate?.didSubmitLogin(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
        } else {
            delegate?.didSubmitRegister(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", email: emailTextField.text ?? "")
        }
    }
    
    func didTapBackButton()
    {
        delegate?.didTapBackButton()
    }
}

// PMARK: UITextFieldDelegate
extension UserControlsView: UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        let textFields: [UITextField] = (type == .Login) ?
            [usernameTextField, passwordTextField] :
            [usernameTextField, passwordTextField, emailTextField]
        
        if let index = textFields.indexOf(textField)
        {
            if (index < textFields.count - 1) {
                textFields[index + 1].becomeFirstResponder()
            } else {
                didTapSubmitButton()
            }
        }
        
        return true
    }
}
