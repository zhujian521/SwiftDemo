//
//  FocusedTableViewCell.swift
//  FirstProject
//
//  Created by zhujian on 18/1/22.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class FocusedTableViewCell: UITableViewCell {
    @IBOutlet weak var followedButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var ImageButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var followedImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureUserInformation(model:AttentionPersonModel) -> Void {
        self.userName.text = model.uName
        let urlString = self.getHeadimgurl(path:model.uHeadimgurl)
        let url = NSURL.init(string:urlString)
        self.userImage.sd_setImage(with: url as URL!, placeholderImage: UIImage.init(named: "avatar"))

    }
    func getHeadimgurl(path:String?) -> String {
        var url = "http://120.77.211.200/"
        url = url + "image/getImg?path="
        if path != nil {
            url = url + path!
            url = NSString.forUTF(url)
            return url
            
        }
        return url
    }

    
}
