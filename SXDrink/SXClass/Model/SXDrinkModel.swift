//
//  SXDrinkModel.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/17.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class SXDrinkModel: NSObject {
    var text : String!
    var isTurnON : Bool = false
    
    init(text: String, isTurnON:Bool){
        self.text = text
        self.isTurnON = isTurnON
    }
}
