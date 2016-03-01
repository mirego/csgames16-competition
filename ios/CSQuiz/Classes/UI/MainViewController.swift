//
//  MainViewController.swift
//  CSQuiz
//
//  Created by Hugo Lefrancois on 2016-02-20.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

class MainViewController: UIViewController
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

        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView()
    {
        view = MainView()

        mainView.refreshButton.addTarget(self, action: Selector("doRefresh"), forControlEvents: .TouchUpInside)
        mainView.addUserButton.addTarget(self, action: Selector("doAddUser"), forControlEvents: .TouchUpInside)

        doRefresh()
    }
}

// PMARK: Control Events
extension MainViewController
{
    func doRefresh()
    {
        userApi.getAllUsers { (users, error) -> () in
            if let users = users {
                self.mainView.configure(users)
            }

            if let error = error {
                print("error: \(error)")
            }

        }
    }

    func doAddUser()
    {
        addUserAlertController = UIAlertController(title: "Add User", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        guard let addUserAlertController = addUserAlertController else { return }

        addUserAlertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Name"
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldTextDidChange", name: UITextFieldTextDidChangeNotification, object: textField)
        }
        addUserAlertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Email"
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldTextDidChange", name: UITextFieldTextDidChangeNotification, object: textField)
        }

        let cleanupAlert = { [weak self] in
            if let strongSelf = self, addUserAlertController = strongSelf.addUserAlertController, textFields = addUserAlertController.textFields {
                textFields.forEach {  NSNotificationCenter.defaultCenter().removeObserver(strongSelf, name: UITextFieldTextDidChangeNotification, object: $0) }
                strongSelf.addUserAlertController = nil
                strongSelf.addAction = nil
            }
        }
        addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { [weak self] (action) -> Void in
            let name = self?.addUserAlertController?.textFields?[0].text
            let email = self?.addUserAlertController?.textFields?[1].text
            self?.userApi.createUser(User.createUser(userId: nil, name: name, email: email), completion: { (error) -> () in
                if let error = error {
                    print(error)
                } else {
                    self?.doRefresh()
                }
            })
            cleanupAlert()
        })
        guard let addAction = addAction else { return }

        addAction.enabled = false

        addUserAlertController.addAction(addAction)
        addUserAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            cleanupAlert()
        }))

        presentViewController(addUserAlertController, animated: true, completion: nil)
    }

    func textFieldTextDidChange()
    {
        if let addUserAlertController = addUserAlertController, addAction = addAction, textFields = addUserAlertController.textFields {
            var enableAddAction = true
            for textField in textFields {
                if textField.text == nil || textField.text!.isEmpty {
                    enableAddAction = false
                    break
                }
            }
            addAction.enabled = enableAddAction
        }
    }
}
