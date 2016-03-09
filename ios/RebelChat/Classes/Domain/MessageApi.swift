//
//  MessageApi.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-08.
//  Copyright © 2016 Mirego. All rights reserved.
//

import Alamofire
import SwiftyJSON

class MessageApi
{
    private static let messageApiURL = "http://localhost:3000/messages"
    
    private let manager: Manager
    
    init()
    {
        let configuration  = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        manager = Manager(configuration: configuration)
    }
    
    func postMessage(message: Message, completion: (message: Message?, error: NSError?) -> ())
    {
        manager.request(.POST, MessageApi.messageApiURL, parameters: message.toDictionary()).response { (request, httpURLResponse, data, error) -> Void in
            if let data = data where error == nil
            {
                let jsonData = JSON(data: data)
                let message = self.jsonToMessage(jsonData)
                completion(message: message, error: error)
            } else {
                completion(message: nil, error: error)
            }
        }
    }
}

// PMARK: Private
extension MessageApi
{
    private func jsonToMessage(json: JSON) -> Message
    {
        return Message.createMessage(
            messageId: json["_id"].string,
            userId: json["userId"].string,
            text: json["text"].string,
            image: UIImage.fromBase64String(json["image"].string ?? "")
        )
    }
}
