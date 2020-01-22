//
//  SXMineSportDataCell.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/17.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class SXMineSportDataCell: UITableViewCell {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var cLabel: UILabel!

    var _sport: Sport?
    var sport : Sport {
        set{
            _sport = newValue
            self.timeLabel.text = _sport?.startTime ?? ""
            self.distanceLabel.text = _sport!.mileage + "公里"
            self.speedLabel.text = _sport!.averageSpeed + "km/h"
            self.aLabel.text = _sport?.averageSettingSpped ?? ""
            self.bLabel.text = _sport?.durationTime ?? ""
            self.cLabel.text = _sport?.calorie ?? ""
        }
        get{
            return _sport ?? Sport()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.detailView.layer.masksToBounds = true
        self.detailView.layer.cornerRadius = 10
        self.detailView.backgroundColor = SXThemeColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
