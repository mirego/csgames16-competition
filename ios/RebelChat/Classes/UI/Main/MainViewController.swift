//
//  MainViewController.swift
//  RebelChat
//
//  Created by Hugo Lefrancois on 2016-02-20.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController
{
    private var mainView: MainView {
        return self.view as! MainView
    }

    private let userApi: UserApi
    private let messageApi: MessageApi

    private var addUserAlertController: UIAlertController?
    private var addAction: UIAlertAction?

    init(userApi: UserApi, messageApi: MessageApi)
    {
        self.userApi = userApi
        self.messageApi = messageApi

        super.init()
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView()
    {
        view = MainView()
        mainView.delegate = self
        mainView.setTopPadding(UIApplication.sharedApplication().statusBarFrame.size.height, repositionSections: false)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillUpdate:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillUpdate:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Unsubscribe to keyboard events
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
}

// PMARK: Private
extension MainViewController
{
    private func presentMessagesViewController(user: User)
    {
        // Show the messages view
        let messagesViewController = MessagesViewController(userId: user.userId ?? "", messageApi: messageApi)
        presentViewController(messagesViewController, animated: true, completion: {
            self.mainView.setState(.MainMenu, animated: false)
        })
    }
}

// PMARK: Keyboard Notifications
extension MainViewController
{
    func keyboardWillUpdate(notification: NSNotification)
    {
        // Update the view controls when the keyboard updates
        if let userInfo = notification.userInfo,
            keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval
        {
            let bottomPadding = CGRectIntersection(view.bounds, keyboardEndFrame.CGRectValue()).height
            mainView.setBottomPadding(bottomPadding, animationDuration: animationDuration)
        }
    }
}

// PMARK: MainViewDelegate
extension MainViewController: MainViewDelegate
{
    func didSubmitLogin(username username: String, password: String)
    {
        showLoadingIndicator()
        
        userApi.getUser(username) { (user, error) -> () in
            if let user = user {
                self.hideLoadingIndicator(success: true, completion: {
                    self.presentMessagesViewController(user)
                })
            } else {
                self.hideLoadingIndicator(success: false, message: LocalizedString("MESSAGE_LOGIN_ERROR"))
            }
        }
    }
    
    func didSubmitRegister(username username: String, password: String, email: String)
    {
        showLoadingIndicator()
        
        let user = User.createUser(userId: nil, name: username, email: email)
        
        userApi.createUser(user) { (user, error) -> () in
            if let user = user {
                self.hideLoadingIndicator(success: true, completion: {
                    self.presentMessagesViewController(user)
                })
            } else {
                self.hideLoadingIndicator(success: false, message: LocalizedString("MESSAGE_REGISTER_ERROR"))
            }
        }
    }
}
