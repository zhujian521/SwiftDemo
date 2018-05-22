//
//  UserTextCell.swift
//  FirstProject
//
//  Created by zhujian on 18/1/6.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class UserTextCell: UITableViewCell {
    @IBOutlet weak var otherLabel: UILabel!

    @IBOutlet weak var titleTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
