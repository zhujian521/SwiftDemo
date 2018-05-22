//
//  TbCircleTableViewCell.swift
//  FirstProject
//
//  Created by zhujian on 18/1/9.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class TbCircleTableViewCell: UITableViewCell {
    @IBOutlet weak var uNameLabel: UILabel!
    @IBOutlet weak var uHeadImage: UIImageView!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var sPhotoView: UIView!
    @IBOutlet weak var sContentView: UIView!
    @IBOutlet weak var cContentLabel: UILabel!
    @IBOutlet weak var cContentHeight: NSLayoutConstraint!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var creatDataLabel: UILabel!
    var tempToolBar = ToolBarView()
    var tempPicture = PictureView()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.uHeadImage.layer.masksToBounds = true
        self.uHeadImage.layer.cornerRadius = 25
        let pictureView = PictureView.init(frame: CGRect.init(x: 0, y: 0, width: sPhotoView.bounds.width, height: sPhotoView.bounds.height))
        pictureView.backgroundColor = UIColor.white
        tempPicture = pictureView
        sPhotoView.addSubview(pictureView)
        
        let toolBar = ToolBarView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 40))
        toolBar.backgroundColor = UIColor.white
        tempToolBar = toolBar
        toolBarView.addSubview(toolBar)
        
        
        
    }
    func configureValue(model:TbCircleModel) -> Void {
        self.uNameLabel.text = model.tbModel.uName
        self.creatDataLabel.text = model.tbModel.cCreateDate
        self.cContentHeight.constant = model.tbModel.cContentHeight
        self.cContentLabel.text = model.tbModel.cContent
        let urlString = self.getHeadimgurl(path:model.tbModel.uHeadimgurl)
        let url = NSURL.init(string:urlString)
        self.uHeadImage.sd_setImage(with: url as URL!, placeholderImage: UIImage.init(named: "avatar"))
        tempPicture.photoArr = model.tbModel.cPhotoArr
        tempPicture.configurePhoto()
        let clo:Int
        if model.tbModel.cPhotoArr.count % 3 == 0 {
            clo = model.tbModel.cPhotoArr.count / 3
        } else {
            clo = model.tbModel.cPhotoArr.count / 3 + 1
            
        }
        let pictureRowHeight = (clo) * (pictureMargin + pictureWidth )
        tempPicture.frame = CGRect.init(x: 0, y: 0, width: Int(kScreenWidth), height:pictureRowHeight)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
