//
//  User.swift
//  CSQuiz
//
//  Created by Hugo Lefrancois on 2016-02-20.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

class User
{
    var userId: String?
    var name: String?
    var email: String?

    class func createUser(userId userId: String?, name: String?, email: String?) -> User
    {
        let user = User()
        user.userId = userId
        user.name = name
        user.email = email

        return user
    }

    func toDictionary() -> [String : String]
    {
        var dictionary: [String : String] = [:]
        if let userId = userId {
            dictionary["_id"] = userId
        }
        if let name = name {
            dictionary["name"] = name
        }
        if let email = email {
            dictionary["email"] = email
        }

        return dictionary
    }
}

extension User: CustomDebugStringConvertible
{
    var debugDescription: String {
        get {
            var debugString = ""
            if let userId = userId {
                debugString += "ID: \(userId) "
            }
            if let name = name {
                debugString += "name: \(name) "
            }
            if let email = email {
                debugString += "email: \(email) "
            }
           return debugString
        }
    }
}