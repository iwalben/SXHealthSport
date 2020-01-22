//
//  SXDrinkCell.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/10.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class SXDrinkCell: UITableViewCell {
    
    @IBOutlet weak var cellTitleL: UILabel!
    
    let smileSwitch : TKSmileSwitch = TKSmileSwitch.init()
    override func awakeFromNib() {
        super.awakeFromNib()
        smileSwitch.backgroundColor = UIColor.clear
        self.addSubview(smileSwitch)
        smileSwitch.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.width.equalTo(75)
            make.height.equalTo(30)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
