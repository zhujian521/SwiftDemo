//
//  ImageCollectionViewCell.swift
//  FirstProject
//
//  Created by zhujian on 18/1/24.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectImage: UIImageView!

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.masksToBounds = true
    }
    //设置是否选中
    open override var isSelected: Bool {
        didSet{
            if isSelected {
                selectImage.image = UIImage(named: "CellBlueSelected")
            }else{
                selectImage.image = UIImage(named: "CellGreySelected")
            }
        }
    }
    //播放动画，是否选中的图标改变时使用
    func playAnimate() {
        //图标先缩小，再放大
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        self.selectImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4,
                                                       animations: {
                                                        self.selectImage.transform = CGAffineTransform.identity
                                    })
        }, completion: nil)
    }


}
