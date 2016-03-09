//
//  Message.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-08.
//  Copyright © 2016 Mirego. All rights reserved.
//

class Message
{
    var messageId: String?
    var userId: String?
    var text: String?
    var image: UIImage?
    
    class func createMessage(messageId messageId: String?, userId: String?, text: String?, image: UIImage?) -> Message
    {
        let message = Message()
        message.messageId = messageId
        message.userId = userId
        message.text = text
        message.image = image
        
        return message
    }
    
    func toDictionary() -> [String : String]
    {
        var dictionary: [String : String] = [:]
        if let messageId = messageId {
            dictionary["_id"] = messageId
        }
        if let userId = userId {
            dictionary["userId"] = userId
        }
        if let text = text {
            dictionary["text"] = text
        }
        if let image = image {
            dictionary["image"] = image.toBase64String()
        }
        
        return dictionary
    }
}

extension Message: CustomDebugStringConvertible
{
    var debugDescription: String {
        get {
            var debugString = ""
            if let messageId = messageId {
                debugString += "ID: \(messageId) "
            }
            if let userId = userId {
                debugString += "User ID: \(userId) "
            }
            if let text = text {
                debugString += "Text: \(text) "
            }
            if let image = image {
                debugString += "Image: \(image) "
            }
            return debugString
        }
    }
}
