//
//  UserApi.swift
//  RebelChat
//
//  Created by Hugo Lefrancois on 2016-02-20.
//  Copyright © 2016 Mirego. All rights reserved.
//

import Alamofire
import SwiftyJSON

class UserApi
{
    private static let userApiURL = "http://localhost:3000/users"

    private let manager: Manager

    init()
    {
        let configuration  = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        manager = Manager(configuration: configuration)
    }
    
    func getUser(username: String, completion: (user: User?, error: NSError?) -> ())
    {
        let parameters = ["name": username]
        
        manager.request(.GET, UserApi.userApiURL, parameters: parameters).response { (request, httpURLResponse, data, error) -> Void in
            if let data = data
            {
                let jsonData = JSON(data: data)
                let users = self.jsonToUsers(jsonData)
                completion(user: users.first, error: error)
            } else {
                completion(user: nil, error: error)
            }
        }
    }

    func getAllUsers(completion: (users: [User]?, error: NSError?) -> ())
    {
        manager.request(.GET, UserApi.userApiURL).response { (request, httpURLResponse, data, error) -> Void in
            if let data = data
            {
                let jsonData = JSON(data: data)
                let users = self.jsonToUsers(jsonData)
                completion(users: users, error: error)
            } else {
                completion(users: nil, error: error)
            }
        }
    }

    func createUser(user: User, completion: (user: User?, error: NSError?) -> ())
    {
        manager.request(.POST, UserApi.userApiURL, parameters: user.toDictionary()).response { (request, httpURLResponse, data, error) -> Void in
            if let data = data
            {
                let jsonData = JSON(data: data)
                let user = self.jsonToUser(jsonData)
                completion(user: user, error: error)
            } else {
                completion(user: nil, error: error)
            }
        }
    }

    func updateUser(user: User, completion: (user: User?, error: NSError?) -> ())
    {
        guard let userId = user.userId else {
            completion(user: nil, error: NSError(domain: "No user id", code: -1, userInfo: nil))
            return
        }

        manager.request(.PUT, UserApi.userApiURL + "/\(userId)", parameters: user.toDictionary()).response { (request, httpURLResponse, data, error) -> Void in
            if let data = data
            {
                let jsonData = JSON(data: data)
                let user = self.jsonToUser(jsonData)
                completion(user: user, error: error)
            } else {
                completion(user: nil, error: error)
            }
        }
    }
}

// PMARK: Private
extension UserApi
{
    private func jsonToUsers(json: JSON) -> [User]
    {
        var users = [User]()
        
        if let jsonUsers = json.array {
            jsonUsers.forEach({ (user) -> () in
                users.append(jsonToUser(user))
            })
        }
        
        return users
    }
    
    private func jsonToUser(json: JSON) -> User
    {
        return User.createUser(
            userId: json["_id"].string,
            name: json["name"].string,
            email: json["email"].string
        )
    }
}
