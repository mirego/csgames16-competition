//
//  MainView.swift
//  CSQuiz
//
//  Created by Hugo Lefrancois on 2016-02-20.
//  Copyright © 2016 Mirego. All rights reserved.
//

import UIKit
import MCUIViewLayout

class MainView: UIView
{
    private let scrollView = UIScrollView()
    private let title = UILabel()
    private var userLabels: [UILabel] = []
    let refreshButton = UIButton(type: .Custom)
    let addUserButton = UIButton(type: .Custom)

    init()
    {
        super.init(frame: CGRect.zero)

        addSubview(scrollView)

        title.font = UIFont.boldSystemFontOfSize(20)
        title.text = "USERS"
        title.sizeToFit()
        scrollView.addSubview(title)

        configureButton(refreshButton, title: "Refresh")

        configureButton(addUserButton, title: "Add User")
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()

        scrollView.mc_setSize(mc_size())

        title.mc_setPosition(.PositionTopHCenter, withMargins: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))

        var currentY = CGRectGetMaxY(title.frame) + 20
        userLabels.forEach {
            $0.mc_setPosition(.PositionTopLeft, withMargins: UIEdgeInsets(top: currentY, left: 20, bottom: 0, right: 0), size: CGSize(width: mc_width() - 40, height: $0.mc_height()))
            currentY += $0.mc_height() + 10
        }

        refreshButton.mc_setPosition(.PositionTopHCenter, withMargins: UIEdgeInsets(top: currentY + 10, left: 0, bottom: 0, right: 0))

        addUserButton.mc_setRelativePosition(.RelativePositionUnderCentered, toView: refreshButton, withMargins: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))

        scrollView.contentSize = CGSize(width: scrollView.mc_width(), height: CGRectGetMaxY(addUserButton.frame) + 20)
    }

    func configure(users: [User])
    {
        userLabels.forEach { $0.removeFromSuperview() }
        userLabels.removeAll()

        users.forEach {
            let userLabel = UILabel()
            userLabel.text = "\($0.name ?? "") - \($0.email ?? "")"
            userLabel.sizeToFit()
            scrollView.addSubview(userLabel)
            userLabels.append(userLabel)
        }

        setNeedsLayout()
    }
}

extension MainView
{
    private func configureButton(button: UIButton, title: String)
    {
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(tintColor, forState: .Normal)
        button.setTitleColor(tintColor.colorWithAlphaComponent(0.6), forState: .Highlighted)
        button.sizeToFit()
        button.mc_setHeight(44)
        scrollView.addSubview(button)
    }
}
