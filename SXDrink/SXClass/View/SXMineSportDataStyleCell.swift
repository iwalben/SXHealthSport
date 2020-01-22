//
//  SXMineSportDataStyleCell.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/16.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class SXMineSportDataStyleCell: UITableViewCell {

    @IBOutlet weak var mainL: UILabel!
    @IBOutlet weak var subL: UILabel!
    @IBOutlet weak var containBackImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.containBackImageView.layer.masksToBounds = true
        self.containBackImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
