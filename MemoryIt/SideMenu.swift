//
//  SideMenu.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/25.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit

class SideMenu: RESideMenu, RESideMenuDelegate {

    override func awakeFromNib() {
        menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        contentViewShadowColor = UIColor.blackColor()
        contentViewShadowOffset = CGSizeMake(0, 0)
        contentViewShadowOpacity = 0.6
        contentViewShadowRadius = 12
        contentViewShadowEnabled = true
        
        contentViewController = storyboard?.instantiateViewControllerWithIdentifier("contentViewController") as UIViewController
        leftMenuViewController = storyboard?.instantiateViewControllerWithIdentifier("leftViewController") as UIViewController
        rightMenuViewController = storyboard?.instantiateViewControllerWithIdentifier("leftViewController") as UIViewController
        backgroundImage = UIImage(named: "Stars")
        delegate = self
    }

}
