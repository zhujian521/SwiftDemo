//
//  MessageHeadView.swift
//  FirstProject
//
//  Created by zhujian on 18/1/18.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class MessageHeadView: UIView,JJPhotoDelegate {
    var tempModel:TbCircleModel!
    var tempImage = [UIImageView]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatSubViews() -> Void {
        let userImage = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 50, height: 50))
        userImage.backgroundColor = UIColor.white
        self.addSubview(userImage)
        
        let urlString = self.getHeadimgurl(path:self.tempModel.tbModel.uHeadimgurl)
        let url = NSURL.init(string:urlString)
        userImage.sd_setImage(with: url as URL!, placeholderImage: UIImage.init(named: "avatar"))
        
        let userName = UILabel.init(frame: CGRect.init(x: userImage.frame.origin.x + userImage.bounds.width + 10, y: 10, width: 200, height: 20))
        userName.font = UIFont.systemFont(ofSize: 15)
        userName.text = self.tempModel.tbModel.uName
        self.addSubview(userName)
        
        let creatTime = UILabel.init(frame: CGRect.init(x: userImage.frame.origin.x + userImage.bounds.width + 10, y: 10 + 25, width: 200, height: 20))
        creatTime.text = self.tempModel.tbModel.cCreateDate
        creatTime.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(creatTime)
        
        let commentLabel = UILabel.init(frame: CGRect.init(x: 10, y: userImage.frame.origin.y + userImage.frame.size.height + 10, width: UIScreen.main.bounds.width - 20, height: self.tempModel.tbModel.cContentHeight))
        commentLabel.numberOfLines = 0
        commentLabel.font = UIFont.systemFont(ofSize: 16)
        commentLabel.text = self.tempModel.tbModel.cContent
        commentLabel.backgroundColor = UIColor.white
        self.addSubview(commentLabel)
        if self.tempModel.tbModel.sType == "1" {
            var PhotoMaxCol = 3
            if  self.tempModel.tbModel.cPhotoArr.count == 4 {
                PhotoMaxCol = 2
            } else {
                PhotoMaxCol = 3
                
            }
            let pictureRowHeight:Int
                let tmpeClo:Int
                if self.tempModel.tbModel.cPhotoArr.count % 3 == 0 {
                    tmpeClo = self.tempModel.tbModel.cPhotoArr.count / 3
                } else {
                    tmpeClo = self.tempModel.tbModel.cPhotoArr.count / 3 + 1
                    
                }
                pictureRowHeight = (tmpeClo) * (pictureMargin + pictureWidth + 8)
            let tempView = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(commentLabel.frame.origin.y + commentLabel.frame.size.height), width: kScreenWidth, height: CGFloat(pictureRowHeight)))
            tempView.backgroundColor = UIColor.white
            self.addSubview(tempView)
           

            for index in self.tempModel.tbModel.cPhotoArr.indices {
                let clo = index / PhotoMaxCol
                let row = index % PhotoMaxCol
                let tempImage = UIImageView.init()
                //commentLabel.frame.origin.y + commentLabel.frame.size.height +
                tempImage.frame = CGRect.init(x: CGFloat(pictureMargin + row * (pictureWidth + pictureMargin)), y: CGFloat(clo * (pictureWidth + pictureMargin)) + 10, width: CGFloat(pictureWidth), height: CGFloat(pictureWidth))
                tempImage.backgroundColor = UIColor.blue
                tempImage.contentMode = .scaleAspectFill
                tempImage.layer.masksToBounds = true
                tempImage.isUserInteractionEnabled = true
                tempImage.isUserInteractionEnabled = true
                tempImage.tag = index
                tempView.addSubview(tempImage)
                let urlString = self.tempModel.tbModel.cPhotoArr[index]
                let url = self.getHeadimgurl(path: urlString)
                tempImage.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.init(named: ""))
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleTapPicture(_:)))
                tempImage.addGestureRecognizer(tapGesture)
                self.tempImage.append(tempImage)
                
            }

        } else {
            let tempImage = UIImageView.init()
            tempImage.frame = CGRect.init(x: 10, y: commentLabel.frame.origin.y + commentLabel.frame.size.height + 10, width: kScreenWidth - 20, height:  kScreenWidth - 30)
            tempImage.backgroundColor = UIColor.blue
            tempImage.contentMode = .scaleAspectFill
            tempImage.layer.masksToBounds = true
            tempImage.isUserInteractionEnabled = true
            self.addSubview(tempImage)
            let videoString = self.getHeadimgurl(path: self.tempModel.tbModel.sVideoImage)
            let videoUrl = NSURL.init(string:videoString)
            tempImage.sd_setImage(with: videoUrl as URL!, placeholderImage: UIImage.init(named: "AccordingParking"))
            let playButton = UIButton.init(frame: CGRect.init(x: tempImage.frame.size.width / 2 - 25, y: tempImage.frame.size.height / 2 - 25, width: 50, height: 50))
            playButton.setImage(UIImage.init(named: "play"), for: .normal)
            tempImage.addSubview(playButton)

            
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
    func handleTapPicture(_ sender:UITapGestureRecognizer) -> Void {
        let image:UIImageView = sender.view as! UIImageView
        print(image.tag)
        let photoManeger = JJPhotoManeger()
        photoManeger.delegate = self
        photoManeger.showLocalPhotoViewer(self.tempImage, selecView: image)
        
    }
    func photoViwerWilldealloc(_ selecedImageViewIndex: Int) {
        
    }




}
