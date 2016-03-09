//
//  Easing.swift
//  RebelChat
//
//  Created by Émile Bélair on 2016-03-08.
//  Copyright © 2016 Mirego. All rights reserved.
//

import Foundation

func easeIn(x: CGFloat) -> CGFloat
{
    return max(0, min(1, x * x))
}

func easeOut(x: CGFloat) -> CGFloat
{
    return max(0, min(1, 1 - (1 - x) * (1 - x)))
}

func easeInOut(x: CGFloat) -> CGFloat
{
    return max(0, min(1, x < 0.5 ? (2 * x * x) : -1 + (4 - 2 * x) * x))
}
