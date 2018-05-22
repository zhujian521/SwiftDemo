//
//  CustomTextView.swift
//  FirstProject
//
//  Created by zhujian on 18/1/17.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class CustomTextView: UIView,UITextViewDelegate {
    var textViewTest : UITextView = UITextView()
    var placeHolLabel : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.creatSubViews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatSubViews() -> Void {
        let feedbackTextView = UITextView()
        feedbackTextView.delegate = self
        self.textViewTest = feedbackTextView
        feedbackTextView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: 150)
        feedbackTextView.backgroundColor = UIColor.white
        feedbackTextView.font = UIFont.boldSystemFont(ofSize: 16)
        self.addSubview(feedbackTextView)
        
        let placeHolderLabel = UILabel()
        self.placeHolLabel = placeHolderLabel
        placeHolderLabel.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: 30)
        placeHolderLabel.font = UIFont.systemFont(ofSize: 18)
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.text = "非常期待您见解"
        placeHolderLabel.alpha = 0.25
        self.addSubview(placeHolderLabel)
    

    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.placeHolLabel.isHidden = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeHolLabel.isHidden = false  // 显示
        }
        else{
            self.placeHolLabel.isHidden = true  // 隐藏
        }
        print("textViewDidEndEditing")
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("shouldChangeTextInRange")
        if text == "\n"{ // 输入换行符时收起键盘
//            textView.resignFirstResponder() // 收起键盘
        }
        return true
    }

    
}
