//
//  MyForumModel.swift
//  FirstProject
//
//  Created by zhujian on 18/2/26.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyForumModel: NSObject {
    var fId:String!
    var fName:String!
    init(dic:JSON) {
        super.init()
        self.fId = dic["fId"].stringValue
        self.fName = dic["fName"].stringValue
    
    }

}
