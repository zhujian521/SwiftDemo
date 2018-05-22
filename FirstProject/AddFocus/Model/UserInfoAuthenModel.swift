//
//  UserInfoAuthenModel.swift
//  FirstProject
//
//  Created by zhujian on 18/1/22.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserInfoAuthenModel: NSObject {
    var uSex:String!
    var uHeadimgurl:String!
    var uType:String!
    var token:String!
    var uName:String!
    var uRegisterDate:String!
    var uId:String!
    var aEnterpriseName:String!
    var fanNum:String!
    var attentionNum:String!
    init(dic:JSON) {
        super.init()
        self.uSex = dic["uSex"].stringValue
        self.uHeadimgurl = dic["uHeadimgurl"].stringValue
        self.uType = dic["uType"].stringValue
        self.uName = dic["uName"].stringValue
        self.token = dic["token"].stringValue
        self.uId = dic["uId"].stringValue
        self.uRegisterDate = dic["uRegisterDate"].stringValue
        self.aEnterpriseName = dic["aEnterpriseName"].stringValue
        
    }



}
