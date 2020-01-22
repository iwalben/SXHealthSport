//
//  SXMacro.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/10.
//  Copyright © 2020 Roddick. All rights reserved.
//

import Foundation

//状态栏高度
let SXStatusBarHeight =  UIApplication.shared.statusBarFrame.size.height
//导航栏高度
let SXNavigationHeight = (SXStatusBarHeight + 44)
//tabbar高度
let SXTabBarHeight =  (CGFloat)(SXStatusBarHeight == 44 ? 83 : 49)
//顶部的安全距离
let SXTopSafeAreaHeight = (SXStatusBarHeight - 20)
//底部的安全距离
let SXBottomSafeAreaHeight = (SXTabBarHeight - 49)
//屏幕宽度
let SXScreenW = UIScreen.main.bounds.size.width
//屏幕高度
let SXScreenH = UIScreen.main.bounds.size.height

let SXThemeColor = SXHEXCOLOR(rgbValue:0xDDA0DD)

//16进制转换
func SXHEXCOLOR(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


//颜色转图片
func SXTansportImageWithColor(color:UIColor)->UIImage{
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
