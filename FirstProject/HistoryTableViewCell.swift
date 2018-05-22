//
//  HistoryTableViewCell.swift
//  FirstProject
//
//  Created by zhujian on 17/12/29.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var bicycleNumber: UILabel!
    @IBOutlet weak var creatTime: UILabel!
    @IBOutlet weak var unlockNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
