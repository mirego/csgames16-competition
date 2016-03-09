//
//  Localization.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-08.
//  Copyright © 2016 Mirego. All rights reserved.
//

import Foundation

func LocalizedString(key: String, comment: String = "") -> String
{
    return NSLocalizedString(key, comment: comment)
}
