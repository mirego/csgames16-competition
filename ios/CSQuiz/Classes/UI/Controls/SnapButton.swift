//
//  SnapButton.swift
//  CSQuiz
//
//  Created by Émile Bélair on 2016-03-07.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit

class SnapButton: UIControl
{
    init()
    {
        super.init(frame: CGRectZero)
        
        let buttonSize = CGSize(width: Stylesheet.snapButtonSize, height: Stylesheet.snapButtonSize)
        
        mc_setSize(buttonSize)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
