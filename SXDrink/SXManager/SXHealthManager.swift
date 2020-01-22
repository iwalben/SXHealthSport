//
//  SXHealthManager.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/9.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import HealthKit

typealias stepCompletion = (Double,NSError) -> (Void)

class SXHealthManager: NSObject {
    let healthStore : HKHealthStore =  HKHealthStore.init()
    
    static let shareManager : SXHealthManager = {
        let instance = SXHealthManager()
        return instance
    }()
}



