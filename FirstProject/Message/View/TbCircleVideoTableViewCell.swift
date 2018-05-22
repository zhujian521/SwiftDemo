//
//  TbCircleVideoTableViewCell.swift
//  FirstProject
//
//  Created by zhujian on 18/1/16.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class TbCircleVideoTableViewCell: UITableViewCell {
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var svideoHeight: NSLayoutConstraint!
    @IBOutlet weak var cContentHeight: NSLayoutConstraint!
    @IBOutlet weak var cContentLabel: UILabel!
    @IBOutlet weak var creatDataLabel: UILabel!
    @IBOutlet weak var uHeadImage: UIImageView!
    @IBOutlet weak var uNameLabel: UILabel!
    var tempToolBar = ToolBarView()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.videoImage.layer.masksToBounds = true
        self.videoImage.contentMode = .scaleAspectFill
        self.uHeadImage.layer.masksToBounds = true
        self.uHeadImage.layer.cornerRadius = 25
        self.cContentLabel.numberOfLines = 0
        let toolBar = ToolBarView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 40))
        toolBar.backgroundColor = UIColor.white
        tempToolBar = toolBar
        toolBarView.addSubview(toolBar)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configureValue(model:TbCircleModel) -> Void {
        self.svideoHeight.constant = UIScreen.main.bounds.width - 100
        self.uNameLabel.text = model.tbModel.uName
        self.creatDataLabel.text = model.tbModel.cCreateDate
        self.cContentHeight.constant = model.tbModel.cContentHeight
        self.cContentLabel.text = model.tbModel.cContent
        let urlString = self.getHeadimgurl(path:model.tbModel.uHeadimgurl)
        let url = NSURL.init(string:urlString)
        self.uHeadImage.sd_setImage(with: url as URL!, placeholderImage: UIImage.init(named: "avatar"))
        let videoString = self.getHeadimgurl(path: model.tbModel.sVideoImage)
        let videoUrl = NSURL.init(string:videoString)
        self.videoImage.sd_setImage(with: videoUrl as URL!, placeholderImage: UIImage.init(named: "AccordingParking"))
        
        tempToolBar.setNumber(tbModel: model)

        
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
