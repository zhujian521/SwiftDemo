//
//  BicRelationModel.swift
//  FirstProject
//
//  Created by zhujian on 17/12/29.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit

class BicRelationModel: NSObject {
    var bicycleNumber:String!;
    var code:String!
    var date:String!
    
    init(dict:[String:String]) {
        super.init()
        self.bicycleNumber = dict["bicycleNumber"]
        self.code = dict["code"]
        self.date = dict["date"]
    }
    
    
    
    
}
