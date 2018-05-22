//
//  TbCircleModel.swift
//  FirstProject
//
//  Created by zhujian on 18/1/9.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class TbCircleModel: NSObject {
    var isAttention:String!
    var isLike:String!
    var tbForwards:Array<JSON>!
    var isCollect:String!
    var tbCircle:JSON!
    //tbCircle
    var tbModel:CircleModel!
    
    init(dic:JSON) {
        super.init()
        self.isAttention = dic["isAttention"].stringValue
        self.isLike = dic["isLike"].stringValue
        self.tbForwards = dic["tbForwards"].arrayValue
        self.isCollect = dic["isCollect"].stringValue
        self.tbCircle = dic["tbCircle"]
        self.tbModel = CircleModel.init(dic: self.tbCircle)
        
        
    }

    
    
    
}
