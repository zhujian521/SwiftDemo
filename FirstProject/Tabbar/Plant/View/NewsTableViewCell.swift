//
//  NewsTableViewCell.swift
//  FirstProject
//
//  Created by zhujian on 18/2/8.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var pPhotoImage: UIImageView!
    @IBOutlet weak var uNameLabel: UILabel!
    @IBOutlet weak var pTitleLabel: UILabel!
    @IBOutlet weak var pCommentLabel: UILabel!
    @IBOutlet weak var PhotoHeight: NSLayoutConstraint!
    @IBOutlet weak var PhotoWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pTitleLabel.numberOfLines = 0
        self.selectionStyle = .none
        self.pPhotoImage.contentMode = .scaleAspectFill
        self.pPhotoImage.layer.masksToBounds = true
        self.pPhotoImage.isUserInteractionEnabled = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configureModel(model:CommonPostModel) -> Void {
        self.pTitleLabel.text = model.pTitle
        self.uNameLabel.text = model.uName
        if model.pPhoto.isEmpty {
            self.pPhotoImage.isHidden = true
            self.PhotoWidth.constant = 0
            self.PhotoHeight.constant = 0

        } else {
            self.PhotoWidth.constant = 100
            self.PhotoHeight.constant = 100
            self.pPhotoImage.isHidden = false
            let urlString = model.cPhotoArr[0]
            let url = self.getHeadimgurl(path: urlString)
            self.pPhotoImage.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.init(named: ""))
        }
        print(model.pCommentNumber)
        if model.pCommentNumber! == "0" {
            self.pCommentLabel.text = "暂无评论"

        } else {
            self.pCommentLabel.text = model.pCommentNumber + "评论"

        }
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
