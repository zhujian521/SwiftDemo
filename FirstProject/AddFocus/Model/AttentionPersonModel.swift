//
//  AttentionPersonModel.swift
//  FirstProject
//
//  Created by zhujian on 18/1/20.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class AttentionPersonModel: NSObject {
    var amAttentionUserId:String!
    var uHeadimgurl:String!
    var amCreateDate:String!
    var amId:String!
    var uName:String!
    var amUserId:String!
    var uId:String!
    
    var attentioned:String!
    
    init(dic:JSON) {
        super.init()
        self.amAttentionUserId = dic["amAttentionUserId"].stringValue
        self.uHeadimgurl = dic["uHeadimgurl"].stringValue
        self.amCreateDate = self.timeStampForData(tiemStamp: dic["amCreateDate"].intValue / 1000)
        self.amId = dic["amId"].stringValue
        self.uName = dic["uName"].stringValue
        self.amUserId = dic["amUserId"].stringValue
        self.uId = dic["uId"].stringValue
    }
    func timeStampForData(tiemStamp:Int) -> String {
        let timeInterval:TimeInterval = TimeInterval(tiemStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss" //自定义日期格式
        let time:String = dateformatter.string(from: date as Date)
        return time
        
    }
    

}
