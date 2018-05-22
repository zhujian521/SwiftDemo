//
//  UserPictureCell.swift
//  FirstProject
//
//  Created by zhujian on 18/1/6.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class UserPictureCell: UITableViewCell {

    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.pictureImage.layer.masksToBounds = true
        self.pictureImage.layer.cornerRadius = 5
        self.pictureImage.contentMode = UIViewContentMode.scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
