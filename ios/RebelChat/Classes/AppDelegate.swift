//
//  AppDelegate.swift
//  RebelChat
//
//  Created by Hugo Lefrancois on 2016-02-20.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    let userApi = UserApi()
    let messageApi = MessageApi()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.blackColor()
        window!.rootViewController = MainViewController(userApi: userApi, messageApi: messageApi)
        window!.makeKeyAndVisible()

        return true
    }
}
