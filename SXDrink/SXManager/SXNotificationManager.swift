//
//  SXNotificationManager.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/17.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class SXNotificationManager: NSObject {
    static let manager: SXNotificationManager = {
        let instance = SXNotificationManager()
        return instance
    }()

    func addNotification(dateString : String) -> Void {
        if self.isEqualNotification(dateString: dateString) != nil {
            return
        }
        let notification = UILocalNotification.init()
        notification.category = LOCALNOTIFICATIONKEY
        notification.timeZone = NSTimeZone.default
        notification.alertBody = "到了喝水的时间"
        notification.alertTitle = "喝水提醒"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = 0
        let formate = DateFormatter.init()
        formate.dateFormat = "HH:mm"
        let date = formate.date(from: dateString)
        notification.fireDate = date
        notification.repeatInterval = .NSDayCalendarUnit
        notification.userInfo = ["time":dateString]
        UIApplication.shared.scheduleLocalNotification(notification)
        print("提醒设置成功" + dateString)
    }
    
    func cancelAllNotificaton() -> Void {
        UIApplication.shared.cancelAllLocalNotifications()
    }

    func calcleNotificationForDate(dateString:String) -> Void {
        let notif = self.isEqualNotification(dateString: dateString)
        if  notif != nil {
            UIApplication.shared.cancelLocalNotification(notif!)
        }
    }
    
    func isEqualNotification(dateString:String) -> (UILocalNotification?) {
        let items :[UILocalNotification] = UIApplication.shared.scheduledLocalNotifications ?? []
        for item in items {
            if item.category != nil && item.category == LOCALNOTIFICATIONKEY {
                if dateString == item.userInfo!["time"] as! String{
                    return item
                }
            }
        }
        return nil
    }
}
