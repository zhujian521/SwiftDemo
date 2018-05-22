//
//  SexTableViewCell.swift
//  FirstProject
//
//  Created by zhujian on 18/1/8.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class SexTableViewCell: UITableViewCell {

    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var sexLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
