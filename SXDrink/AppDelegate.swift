//
//  AppDelegate.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/8.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import SCLAlertView
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame:UIScreen.main.bounds)
        _ = SXBDManager.manager.start()
        SXSportDataManager.shareManager.configuralRealm()
        let settting = UIUserNotificationSettings.init(types: [.alert,.badge,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settting)
        window?.makeKeyAndVisible()
        let tabbarvc = SXTabBarController.init()

        tabbarvc.addRootChild(childController: SXHomeController.init(), title: "运动", normalImageName: "", selectedImageName: "")
        tabbarvc.addRootChild(childController: SXDrinkController.init(), title: "喝水", normalImageName: "", selectedImageName: "")
        tabbarvc.addRootChild(childController: SXMineController.init(), title: "我的", normalImageName: "", selectedImageName: "")
        window?.rootViewController = tabbarvc
        return true
    }
    
    //MARK: 接收到本地通知
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if notification.category == LOCALNOTIFICATIONKEY {
            SCLAlertView().showInfo("温馨提示", subTitle: "到了喝水的时间")
        }
    }
}

