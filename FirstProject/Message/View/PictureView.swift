//
//  PictureView.swift
//  FirstProject
//
//  Created by zhujian on 18/1/16.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class PictureView: UIView,SDPhotoBrowserDelegate {
    var photoArr:Array<String>!
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
    func configurePhoto() -> Void {
        self.tempImage.removeAll()
        while self.subviews.count < photoArr.count {
            let photoImage = UIImageView.init()
            photoImage.contentMode = .scaleAspectFill
            photoImage.layer.masksToBounds = true
            photoImage.isUserInteractionEnabled = true
            self.addSubview(photoImage)
            
        }
        for index in self.subviews.indices {
            let tempImage = self.subviews[index] as! UIImageView
            
            if index < photoArr.count {
                tempImage.isHidden = false
                tempImage.tag = index
                let urlString = photoArr[index]
                let url = self.getHeadimgurl(path: urlString)
                tempImage.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.init(named: ""))
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleTapPicture(_:)))
                tempImage.addGestureRecognizer(tapGesture)
                self.tempImage.append(tempImage)
                
            } else {
                tempImage.isHidden = true
            }
        }
       
    }
    func handleTapPicture(_ sender:UITapGestureRecognizer) -> Void {
        let image:UIImageView = sender.view as! UIImageView
        print(image.tag)
        let SDPhoto = SDPhotoBrowser.init()
        SDPhoto.delegate = self
        SDPhoto.currentImageIndex = image.tag
        SDPhoto.imageCount = self.photoArr.count
        SDPhoto.sourceImagesContainerView = self
        SDPhoto.show()
        
        
    }
//    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
//        
//    }
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        let Image:UIImageView = self.tempImage[index] 
        return Image.image
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var PhotoMaxCol = 3
        if photoArr.count == 4 {
            PhotoMaxCol = 2
        } else {
            PhotoMaxCol = 3

        }
        for index in photoArr.indices {
            let tempImage = self.subviews[index] as! UIImageView
            let clo = index / PhotoMaxCol
            let row = index % PhotoMaxCol
            
            tempImage.frame = CGRect.init(x: pictureMargin + row * (pictureWidth + pictureMargin), y: pictureMargin + clo * (pictureWidth + pictureMargin), width: pictureWidth, height: pictureWidth)
            tempImage.backgroundColor = UIColor.blue

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
