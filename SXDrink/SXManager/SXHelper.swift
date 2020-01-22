//
//  SXHelper.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/17.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

let LOCALNOTIFICATIONKEY = "SXNotificationManagerKey"
let NOTIFICATIONKEY = "NOTIFICATIONKey"
let SXUSERDATAREMINDKEY = "SXUSERDATAREMIND"

func sx_StringFromeDate(date:Date) -> String {
    let formatter = DateFormatter.init()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date as Date)
}


func sx_StringDayFromeDate(date:Date) -> String {
    let formatter = DateFormatter.init()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date as Date)
}
