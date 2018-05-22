//
//  MyViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/4.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import Alamofire
class MyViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource ,ChangeNameVCDelegate,ChangeSexVCDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    var dataArr = [String]()
    var secondDataArr = [String]()
    var tempTableView:UITableView?
    var tempModel:UserInfoModel?
    var tempImage:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "个人中心"
        self.dataArr.append("头像")
        self.dataArr.append("昵称")
        self.dataArr.append("性别")
        self.dataArr.append("电话号码")
        self.secondDataArr.append("我的收藏")
        self.secondDataArr.append("我的发布")
        self.checkToken()
        self.creatTableView()
        self.requstData()
        
    }
    func creatTableView() -> Void {
        let tableView = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.grouped)
        self.view .addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView.init()
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.01))
        headView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = headView
        tableView .register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib.init(nibName: "UserTextCell", bundle: nil), forCellReuseIdentifier: "text")
        tableView.register(UINib.init(nibName: "UserPictureCell", bundle: nil), forCellReuseIdentifier: "picture")
        tempTableView = tableView

    }
    func requstData() -> Void {
        let param = ["TokenID":String.readToken()];
        self.showMBProgress()
        XMSessionManager.shared.request(Method: .POST, URLString: self.getNMGBaseUrl(actionString: "getUserInfo"), parameters: param as [String : AnyObject]?) { (json:AnyObject?, isSuccess:Bool?) in
            self.hideMBProgress()
            if isSuccess!{
                let dic:[String:AnyObject] = json! as! [String : AnyObject]
                print(dic)
                let status:String = dic["status"] as! String
                let message:String = dic["message"] as! String
                if Int(status) == 1{

                    let userInfo:[String:AnyObject] = dic["UserInfo"]! as! [String:AnyObject]
                    let model:UserInfoModel = UserInfoModel.init(dict: userInfo)
                    self.tempModel = model
                    self.tempTableView?.reloadData()
                } else {
                    self.showMessage(message: message)
                }

            }
        }
    }
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 100;
        }
        return 60;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.dataArr.count
        }
        return self.secondDataArr.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01;
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20;
        }
        return 0;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell:UserPictureCell = tableView.dequeueReusableCell(withIdentifier: "picture", for: indexPath) as! UserPictureCell
            cell.nickNameLabel.text = self.dataArr[indexPath.row]
                let urlString = self.getHeadimgurl(path:self.tempModel?.uHeadimgurl)
                print(urlString)
            let url = NSURL.init(string:urlString)
            self.tempImage = cell.pictureImage
            cell.pictureImage.sd_setImage(with: url as URL!, placeholderImage: UIImage.init(named: "avatar"))
            return cell
        } else if indexPath.section == 1 {
            let cell:UserTextCell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! UserTextCell
            cell.titleTextLabel.text = self.secondDataArr[indexPath.row]
            return cell
        } else {
            
            let cell:UserTextCell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! UserTextCell
            cell.titleTextLabel.text = self.dataArr[indexPath.row]
            if indexPath.row == 1 {
                cell.otherLabel.text = self.tempModel?.uName
 
            } else if indexPath.row == 2{
                cell.otherLabel.text = self.tempModel?.uSex
            } else if indexPath.row == 3{
                cell.otherLabel.text = self.tempModel?.uPhone
            }
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            let vc = ChangeNameVC()
            vc.model = self.tempModel
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.section == 0 && indexPath.row == 2 {
            let vc = ChangeSexVC()
            vc.model = self.tempModel
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.section == 0 && indexPath.row == 0{
            self.changePicture()
        } else if indexPath.section == 1 && indexPath.row == 0{
            let vc = CollectionViewController()
            vc.title = "我的收藏"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func changeUname(name: String) {
        self.tempModel?.uName = name
        self.tempTableView?.reloadData()
    }
    func changeSex(newSex:String) {
        self.tempModel?.uSex = newSex
        self.tempTableView?.reloadData()

    }
    func changePicture() -> Void {
        self.ActionSheet()

    }
    func ActionSheet() {
        
        let alertVC = UIAlertController(title: nil, message: "选择图片", preferredStyle:UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style:.cancel, handler: {
            (action: UIAlertAction) -> Void in
        })
        let okAction1 = UIAlertAction(title: "相机", style:.default, handler: {
            (action: UIAlertAction) -> Void in
            self.selectFromCamera()
        })
        let okAction2 = UIAlertAction(title: "相册", style:UIAlertActionStyle.default, handler: {
            (action: UIAlertAction) -> Void in
            self.selectFromAlbum()
        })
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction1)
        alertVC.addAction(okAction2)
        self.present(alertVC, animated: true, completion: nil)
    }
    func selectFromCamera() -> Void {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = true
        self.present(cameraPicker, animated: true, completion: nil)
    }
    func selectFromAlbum() -> Void {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        photoPicker.allowsEditing = true
        self.present(photoPicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.tempImage?.image = image
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let str = formatter.string(from: NSDate.init() as Date)
        let fileName = str + ".jpg"
        let data = UIImageJPEGRepresentation(image, 0.1)
        var dataArr = Array<Any>()
        dataArr.append(data!)
        let param = ["TokenID":String.readToken()]
        self.showMBProgress()
        NetWorkWeather.sharedInstance.upLoadImageRequest(urlString: "http://120.77.211.200/image/upload", params: param, data: dataArr as! [Data], name: [fileName], success: { (json) -> Void in
            self.hideMBProgress()
            let status:String = json["status"] as! String
            let message:String = json["message"] as! String
            self.showMessage(message: message)
            if status == "1"{
                self.tempModel?.uHeadimgurl = json["filePath"] as! String!
                self.uploadImage(filePath: json["filePath"] as! String!)
            }
            
            
        }) {(error) -> Void in
            self.hideMBProgress()
        }
        
    }
    func uploadImage(filePath:String) -> Void {
        var param = ["TokenID":String.readToken()]
        param.updateValue(filePath, forKey: "uHeadimgurl")
        
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getNMGBaseUrl(actionString: "updateMe"), params: param, success: { (json) -> Void in
//            let status:String = json["status"] as! String
            let message:String = json["message"] as! String
            self.showMessage(message: message)

        }) { (error) -> Void in
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   
}
