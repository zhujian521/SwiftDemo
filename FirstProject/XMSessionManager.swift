//
//  XMSessionManager.swift
//  FirstProject
//
//  Created by zhujian on 17/11/23.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit
import AFNetworking

enum HTTPMethod {
    case GET
    case POST
}
class XMSessionManager: AFHTTPSessionManager {
    //方法一
    static let shared: XMSessionManager = XMSessionManager()
    //方法二
    static let shared1: XMSessionManager = {
        
        // 实例化对象
        let manager = XMSessionManager()
        
        // 设置响应反序列化支持的数据类型
//        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
//        manager.responseSerializer.acceptableContentTypes?.insert("text/json")

        
        // 返回对象
        return manager
    }()
    /// 封装网络请求方法
    ///
    /// - Parameters:
    ///   - Method: GET/POST, 默认是GET请求
    ///   - URLString: 请求地址
    ///   - parameters: 参数
    ///   - completed: 结束回调
    func request(Method:HTTPMethod, URLString: String,parameters: [String: AnyObject]?, completed:@escaping ((_ json: AnyObject?, _ isSuccess: Bool)->())) {
        
        /// 定义成功回调闭包
        let success = { (task: URLSessionDataTask,json: Any?)->() in
            completed(json as AnyObject?,true)
        }
        
        /// 定义失败回调闭包
        let failure = {(task: URLSessionDataTask?, error: Error)->() in
            completed(nil,false)
        }
        
        /// 通过请求方法,执行不同的请求
        // 如果是 GET 请求
        if Method == .GET { // GET
            
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
            
            
        } else { // POST
            
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }



}
