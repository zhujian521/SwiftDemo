//
//  UserInfoModel.swift
//  FirstProject
//
//  Created by zhujian on 18/1/8.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class UserInfoModel: NSObject {
    var tbOpenid:String!
    var uAuthenticationStatus:String!
    var uAuthenticationStatusAdvertisement:String!
    var uCity:String!
    var uCountry:String!
    var uHeadimgurl:String!
    var uId:String!
    var uName:String!
    var uPhone:String!
    var uProvince:String!
    var uRegisterDate:String!
    var uSex:String!
    
    init(dict:[String:AnyObject]) {
        super.init()
        
        if dict["tbOpenid"] is NSNull{
            print("yes")
        }
        else{
            self.tbOpenid = dict["tbOpenid"] as! String!
        }
        if !(dict["uAuthenticationStatus"] is NSNull) {
            self.uAuthenticationStatus =  String(describing: dict["uAuthenticationStatus"])
        }
        if !(dict["uAuthenticationStatusAdvertisement"] is NSNull) {
            self.uAuthenticationStatusAdvertisement =  String(describing: dict["uAuthenticationStatusAdvertisement"])
        }

        
        if !(dict["uCity"] is NSNull) {
            self.uCity = dict["uCity"] as! String!
        }
        if !(dict["uCountry"] is NSNull) {
            self.uCountry = dict["uCountry"] as! String!
        }
        if !(dict["uHeadimgurl"] is NSNull) {
            self.uHeadimgurl = dict["uHeadimgurl"] as! String!
        }
        if !(dict["uId"] is NSNull) {
            self.uId = String(describing: dict["uId"])
        }
        if !(dict["uName"] is NSNull) {
            self.uName = dict["uName"] as! String!
        }
        if !(dict["uPhone"] is NSNull) {
            self.uPhone = dict["uPhone"] as! String!
        }
        if !(dict["uProvince"] is NSNull) {
            self.uProvince = dict["uProvince"] as! String!
        }
        if !(dict["uSex"] is NSNull) {
            self.uSex = dict["uSex"] as! String!
        }
        let tempDate:Int = Int(String(describing: dict["uRegisterDate"]!))!
        self.uRegisterDate = self.timeStampForData(tiemStamp: tempDate / 1000)
        
    }
    func timeStampForData(tiemStamp:Int) -> String {
        let timeInterval:TimeInterval = TimeInterval(tiemStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss" //自定义日期格式
        let time:String = dateformatter.string(from: date as Date)
        print("======\(time)")
        return time

    }

    
    
    
    
    
    
    

}
