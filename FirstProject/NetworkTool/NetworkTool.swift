//
//  NetworkTool.swift
//  FirstProject
//
//  Created by zhujian on 17/12/29.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit
import AFNetworking
class NetworkTool: AFHTTPSessionManager {

    static let shared = NetworkTool()

    func reqeust(url: String, paramaters: [String: Any]? = nil, method: String, callBack:@escaping (_ responseObject:Any?)->()){
        
        //抽取请求成功和失败的闭包
        let success = {
            (task: URLSessionDataTask, responseObject: Any?) in callBack(responseObject)
        }
        let failure = {
            (task: URLSessionDataTask?,error: Error) in
            callBack(nil)
        }
        
        //GET请求网络数据
        if method == "GET" {
            self.get(url, parameters: paramaters, progress: nil, success: success, failure: failure)
        }
        //POST请求网络数据
        if method == "POST" {
            self.post(url, parameters: paramaters, progress: nil, success: success, failure: failure)
        }
    }
    
}
