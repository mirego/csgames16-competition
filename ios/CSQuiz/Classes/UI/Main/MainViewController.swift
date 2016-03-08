//
//  MainViewController.swift
//  CSQuiz
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

    private var addUserAlertController: UIAlertController?
    private var addAction: UIAlertAction?

    init(userApi: UserApi)
    {
        self.userApi = userApi

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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillUpdate:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillUpdate:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
}

// PMARK: Keyboard Notifications
extension MainViewController
{
    func keyboardWillUpdate(notification: NSNotification)
    {
        if let userInfo = notification.userInfo,
            keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval
        {
            let bottomPadding = CGRectIntersection(view.bounds, keyboardEndFrame.CGRectValue()).height
            mainView.setBottomPadding(bottomPadding, animationDuration: animationDuration)
        }
    }
}

extension MainViewController: MainViewDelegate
{
    func didSubmitLogin(username username: String, password: String)
    {
        showLoadingIndicator()
        
        userApi.getUser(username) { (user, error) -> () in
            NSLog("\(user)")
            // TODO
            
            if let user = user {
                self.hideLoadingIndicator(success: true, completion: {
                    // TODO
                })
            } else {
                self.hideLoadingIndicator(success: false, message: LocalizedString("MESSAGE_LOGIN_ERROR"), completion: {
                    // TODO
                })
            }
        }
    }
    
    func didSubmitRegister(username username: String, password: String, email: String)
    {
        showLoadingIndicator()
        
        userApi.createUser(User.createUser(userId: nil, name: username, email: email)) { (user, error) -> () in
            NSLog("\(user)")
            // TODO
            
            if let user = user {
                self.hideLoadingIndicator(success: true, completion: {
                    // TODO
                })
            } else {
                self.hideLoadingIndicator(success: false, message: LocalizedString("MESSAGE_REGISTER_ERROR"), completion: {
                    // TODO
                })
            }
        }
    }
}
