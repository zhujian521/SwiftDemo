//
//  CommentTableViewCell.swift
//  FirstProject
//
//  Created by zhujian on 18/1/18.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var cContenHeight: NSLayoutConstraint!
    @IBOutlet weak var creatTime: UILabel!
    @IBOutlet weak var uName: UILabel!
    @IBOutlet weak var uContent: UILabel!
    @IBOutlet weak var uImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.uImage.layer.masksToBounds = true
        self.uImage.layer.cornerRadius = 25

    }
    func configureValue(model:CommentModel) -> Void {
        self.uName.text = model.uName
        self.creatTime.text = model.fCreateDate
        self.uContent.text = model.fShareContent
        self.cContenHeight.constant = model.cContentHeight
        let urlString = self.getHeadimgurl(path:model.uHeadimgurl)
        let url = NSURL.init(string:urlString)
        self.uImage.sd_setImage(with: url as URL!, placeholderImage: UIImage.init(named: "avatar"))
    }
    func configureContentString(model:CommentStringModel) -> Void {
        self.uName.text = model.uName
        self.creatTime.text = model.cCreateDate
        self.uContent.text = model.cContent
        self.cContenHeight.constant = model.cContentHeight
        let urlString = self.getHeadimgurl(path:model.uHeadimgurl)
        let url = NSURL.init(string:urlString)
        self.uImage.sd_setImage(with: url as URL!, placeholderImage: UIImage.init(named: "avatar"))

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
