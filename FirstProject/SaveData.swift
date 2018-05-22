//
//  SaveData.swift
//  FirstProject
//
//  Created by zhujian on 17/11/23.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import Foundation
import UIKit
extension String {
    
   static  func saveUserInformation(param:[String:AnyObject]) -> Void {
        let type:String = String(describing: param["type"]!)
        let userId:String = String(describing: param["userId"]!)
        let user = UserDefaults.standard
        user.set(type, forKey: "type")
        user.set(userId, forKey: "userId")
        user.synchronize()
        
    }
   static func readingData() -> ([String:String]) {
        let user = UserDefaults.standard
        var type:String
        var userId:String
        if let temp1 = user.object(forKey: "type") , let tem2 = user.object(forKey: "userId"){
            type = String(describing:temp1)
            userId = tem2 as! String
            
        } else {
            type = ""
            userId = ""
        }
        var dic:[String:String]
        dic = ["type":type,"userId":userId]
        return dic
    }
   static func readToken() -> String {
        let user = UserDefaults.standard
        var token:String
        if let temp = user.object(forKey: "Token") {
            token = temp as! String;
        } else {
            token = ""
        }
        return token
    }
    static func saveTokenID(token:String) ->Void {
        let user = UserDefaults.standard
        user.set(token, forKey: "Token")
        user.synchronize()

    }
   static func cleanData() -> Void {
        let user = UserDefaults.standard
        user.set("", forKey: "type")
        user.set("", forKey: "userId")
        user.synchronize()
        
        
    }
    static func cleanToken() -> Void {
        let user = UserDefaults.standard
        user.set("", forKey: "Token")
        user.synchronize()
    }
    static func saveUid(uid:String) {
        let user = UserDefaults.standard
        user.set(uid, forKey: "uId")
        user.synchronize()

        
    }
    static func readUid() -> String {
        let user = UserDefaults.standard
        var uid:String
        if let temp = user.object(forKey: "uId") {
            uid = temp as! String;
        } else {
            uid = ""
        }
        return uid

    }

    

}
extension UIButton {
    func setUpButton() -> Void {
        self.setBackgroundImage(UIImage.init(named: "chongzhi_sel"), for: UIControlState.normal)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
    }
    public func countDown(count: Int){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        
        // 保存当前的背景颜色
        let defaultColor = self.backgroundColor
        // 设置倒计时,按钮背景颜色
        backgroundColor = UIColor.gray
        
        var remainingCount: Int = count {
            willSet {
                setTitle("重新发送(\(newValue))", for: .normal)
                
                if newValue <= 0 {
                    setTitle("获取验证码", for: .normal)
                }
            }
        }
        
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.backgroundColor = defaultColor
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
  
}
