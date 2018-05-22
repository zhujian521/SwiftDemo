//
//  BaseViewController.swift
//  FirstProject
//
//  Created by zhujian on 17/11/21.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseViewController: UIViewController {
    // 屏幕的宽
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    // 屏幕的高
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    //
    var tempMBU = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGBA(r: 246, g: 246, b: 246, a: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont.systemFont(ofSize: 15)]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func checkToken() -> Void {
        let token = String.readToken()
        if token.characters.count == 0 {
            return;
        }
        let param = ["TokenID":token]
        NetWorkWeather.sharedInstance.getRequest(urlString: self.getNMGBaseUrl(actionString: "isLoginStatus"), params: param, success: { (json) -> Void in
            let jsonDic = JSON(json)
            print("====\(jsonDic)")
            let status:String = jsonDic["status"].stringValue
            if status == "0"{
                self.showAlertController()
            }
                


        }) { (error) -> Void in
            
        }
        
        
    }
    func showAlertController() -> Void {
         tempMBU.hide(animated: true)
        let alertVC = UIAlertController.init(title: "提示", message: "登录过期了", preferredStyle: .alert)
        let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
            String.cleanData()
            String.cleanToken()
            self.changeLogInAsWindow()
        }
        alertVC.addAction(acSure)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    func changeTabbarAsWindow() -> Void {
        let VC = TabBarController()
        let appdelegate = UIApplication.shared.keyWindow
        appdelegate?.rootViewController = VC

    }
    func changeLogInAsWindow() -> Void {
        let appdelegate = UIApplication.shared.keyWindow
        let navigation = UINavigationController.init(rootViewController: LogInViewController())
        appdelegate?.rootViewController = navigation
    }
    func getBaseURL(actionString:String) -> (_:String) {
        let   baseUrl = "http://118.31.69.218/odbicycle/bicRelation/api"
//        baseUrl = baseUrl + actionString
        return baseUrl
    }
    func getNMGBaseUrl(actionString:String) -> String {
        var baseUrl = "http://120.77.211.200/userAPP/"
        baseUrl = baseUrl + actionString
        return baseUrl
        
    }
    func getUserNMGBaseUrl(string:String) -> String {
        var url = "http://120.77.211.200/circleAPP/"
        url = url + string
        return url
    }
    func showMBProgress() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)

    }
    func hideMBProgress() -> Void {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->(UIColor) {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    func validatePhoneNumber(email: String) -> Bool {
        let emailRegex = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:email)
    }
    func showMessage(message:String) -> Void {
        let appdelegate = UIApplication.shared.keyWindow
        let MB = MBProgressHUD.showAdded(to: appdelegate!, animated: true)
        MB.bezelView.backgroundColor = UIColor.black
        tempMBU = MB
        MB.mode = MBProgressHUDMode.text;
        MB.label.text = message;
        MB.label.numberOfLines = 0;
        MB.label.textColor = UIColor.white
        MB.label.textAlignment = NSTextAlignment.left;
        MB.hide(animated: true, afterDelay: 1.0);
        
        
    }
    func getHeadimgurl(path:String?) -> String {
        var url = "http://120.77.211.200/"
        url = url + "image/getImg?path="
        if path != nil {
            url = url + path!
           url = NSString.forUTF(url)
            return url

        }
        return url
    }

}
