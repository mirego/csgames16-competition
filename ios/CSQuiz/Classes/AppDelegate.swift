//
//  AppDelegate.swift
//  CSQuiz
//
//  Created by Hugo Lefrancois on 2016-02-20.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        window!.rootViewController = MainViewController(userApi: UserApi())
        window!.makeKeyAndVisible()

        return true
    }
}
