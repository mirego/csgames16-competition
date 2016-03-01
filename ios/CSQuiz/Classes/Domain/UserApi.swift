//
//  UserApi.swift
//  CSQuiz
//
//  Created by Hugo Lefrancois on 2016-02-20.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserApi
{
    private static let usersApiURL = "http://localhost:3000/users"

    private let manager: Manager

    init()
    {
        let configuration  = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        manager = Manager(configuration: configuration)
    }

    func getAllUsers(completion: (users: [User]?, error: NSError?) -> ())
    {
        manager.request(.GET, UserApi.usersApiURL).response { (request, httpURLResponse, data, error) -> Void in
            if let data = data
            {
                let jsonData = JSON(data: data)
                var users: Array<User> = []

                if let jsonUsers = jsonData.array {
                    jsonUsers.forEach({ (user) -> () in
                        users.append(User.createUser(
                            userId: user["_id"].string,
                            name: user["name"].string,
                            email: user["email"].string
                        ))
                    })

                }
                completion(users: users, error: error)
            } else {
                completion(users: nil, error: error)
            }
        }
    }

    func createUser(user: User, completion: (error: NSError?) -> ())
    {
        manager.request(.POST, UserApi.usersApiURL, parameters: user.toDictionary()).response { (request, httpURLResponse, data, error) -> Void in
            completion(error: error)
        }
    }

    func updateUser(user: User, completion: (error: NSError?) -> ())
    {
        guard let userId = user.userId else {
            completion(error: NSError(domain: "no user id", code: -1, userInfo: nil))
            return
        }

        manager.request(.PUT, UserApi.usersApiURL + "/\(userId)", parameters: user.toDictionary()).response { (request, httpURLResponse, data, error) -> Void in
            completion(error: error)
        }
    }
}
