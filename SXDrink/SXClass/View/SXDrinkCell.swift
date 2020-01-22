//
//  SXDrinkCell.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/10.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

//class SXString {
//    var string : String
//    init(s:String) {
//        self.string = s
//    }
//}

class SXDrinkCell: UITableViewCell {
    
    @IBOutlet weak var cellTitleL: UILabel!
    public let smileSwitch : TKSmileSwitch = TKSmileSwitch.init(frame: CGRect(x: SXScreenW-87, y: 13.5, width: 75, height: 30))
    override func awakeFromNib() {
        super.awakeFromNib()
        smileSwitch.backgroundColor = UIColor.clear
        self.addSubview(smileSwitch)
//        smileSwitch.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.right.equalTo(-10)
//            make.width.equalTo(75)
//            make.height.equalTo(30)
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
