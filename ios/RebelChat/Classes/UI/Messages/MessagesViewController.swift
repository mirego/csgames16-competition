//
//  MessagesViewController.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-08.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

class MessagesViewController: BaseViewController
{
    private var mainView: MessagesView {
        return self.view as! MessagesView
    }
    
    let userId: String
    let messageApi: MessageApi
    
    init(userId: String, messageApi: MessageApi)
    {
        self.userId = userId
        self.messageApi = messageApi
        
        super.init()
        
        modalTransitionStyle = .CrossDissolve
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView()
    {
        view = MessagesView()
        mainView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        refreshMainView()
        
        if (animated)
        {
            // Scaling animation when the view appears
            view.transform = CGAffineTransformMakeScale(1.35, 1.35)
            
            UIView.animateWithDuration(Stylesheet.longAnimationDuration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
                self.view.transform = CGAffineTransformMakeScale(1.00, 1.00)
            }, completion: nil)
        }
        else
        {
            view.transform = CGAffineTransformMakeScale(1.00, 1.00)
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if (animated)
        {
            // Scaling animation when the view disappears
            UIView.animateWithDuration(Stylesheet.longAnimationDuration * 0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .CurveEaseOut, animations: { () -> Void in
                self.view.transform = CGAffineTransformMakeScale(1.35, 1.35)
            }, completion: nil)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}

// PMARK: Private
extension MessagesViewController
{
    private func refreshMainView()
    {
        // Sets a random text string and loads the sample image in the message canvas
        let text = randomString(16)
        let image = UIImage(named: "sample-bg", inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil)
        
        mainView.configure(text: text, image: image)
    }
}

extension MessagesViewController: MessagesViewDelegate
{
    func didTapLogoutButton()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapShuffleButton()
    {
        refreshMainView()
    }
    
    func didTapSnapButton(text text: String, imageFromView view: UIView)
    {
        let image = view.snapshot()
        
        showLoadingIndicator()
        
        let message = Message.createMessage(
            messageId: nil,
            userId: userId,
            text: text,
            image: image
        )
        
        messageApi.postMessage(message) { (message, error) -> () in
            if let _ = message {
                self.hideLoadingIndicator(success: true, message: LocalizedString("MESSAGE_POST_MESSAGE_SUCCESS"))
            } else {
                self.hideLoadingIndicator(success: false, message: LocalizedString("MESSAGE_POST_MESSAGE_ERROR"))
            }
        }
    }
}
