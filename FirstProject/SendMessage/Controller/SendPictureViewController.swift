//
//  SendPictureViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/23.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class SendPictureViewController: BaseViewController,HGImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView:UICollectionView!
    var dataItemArr = [HGImaageModel]()
    var textView:CustomTextView!
    var indexRow:Int!
    var filePath:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "写帖子"
        //用于消除右边边空隙，要不然按钮顶不到最边上
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -10;
        
        self.navigationItem.leftBarButtonItems =  [spacer,CustomBarButton.creatTextBarbuttonItem(name: "取消", target: self, action: #selector(handleCancle))]
        self.navigationItem.rightBarButtonItems = [spacer,CustomBarButton.creatTextBarbuttonItem(name: "确定", target: self, action: #selector(handleSure))]
        
        let textView = CustomTextView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 150))
        self.textView = textView
        self.view.addSubview(textView)
        
        let flowLayout = UICollectionViewFlowLayout();
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 4)/3,
                                     height: (UIScreen.main.bounds.size.width - 4)/3)
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 150, width: kScreenWidth, height: kScreenHeight - 150 - 64), collectionViewLayout: flowLayout);
        collectionView!.backgroundColor = UIColor.white;
        collectionView!.delegate = self;
        collectionView!.dataSource = self;
        self.collectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView!);

 
    }
    func handleCancle() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    func handleSure() -> Void {
        if self.textView.textViewTest.text.isEmpty {
            self.showMessage(message: "请输入内容")
            return
        }
        if self.dataItemArr.count == 0 {
            self.showMessage(message: "请上传图片")
            return
        }
        self.indexRow = 0
        self.filePath = ""
        self.uploadPictureToServer()
        

       
    }
    func ImagePickerFinish(imageArr: Array<HGImaageModel>) {
        print("00000\(imageArr.count)")
        for item:HGImaageModel in imageArr {
            self.dataItemArr.append(item)
        }
        self.collectionView.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1 + self.dataItemArr.count
    }
    // 获取单元格
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取storyboard里设计的单元格，不需要再动态添加界面元素
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! ImageCollectionViewCell
        cell.selectImage.isHidden = true
        if indexPath.row == self.dataItemArr.count {
            cell.imageView.image = UIImage.init(named: "AlbumAddBtn")
            cell.deleteButton.isHidden = true


        } else {
            let model = self.dataItemArr[indexPath.row]
            cell.imageView.image = model.image
            cell.deleteButton.isHidden = false
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(handleActionDelete(_:)), for: .touchUpInside)

        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        self.view.endEditing(true)
        if indexPath.row == self.dataItemArr.count  {
            let vc = HGImagePickerController()
            let navigation = UINavigationController.init(rootViewController: vc)
            vc.delegate = self
            vc.maxSelected = 9 - self.dataItemArr.count
            self.present(navigation, animated: true, completion: nil)
        }
    }
    func handleActionDelete(_ sender:UIButton) -> Void {
        self.dataItemArr.remove(at: sender.tag)
        self.collectionView.reloadData()

        
    }
    func uploadPictureToServer() -> Void {
        if self.indexRow < self.dataItemArr.count {
            let model = self.dataItemArr[self.indexRow]
            let image = model.image as UIImage
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
                if status == "1"{
                    let jsonDic = JSON(json)
                    if self.indexRow == self.dataItemArr.count - 1 {
                        self.filePath = self.filePath + jsonDic["filePath"].stringValue

                    } else {
                        self.filePath = self.filePath + jsonDic["filePath"].stringValue + ","
 
                    }
                    self.indexRow = self.indexRow + 1
                    if self.indexRow < self.dataItemArr.count {
                        self.uploadPictureToServer()

                    } else {
                        print(self.filePath)
                        self.sendTextToServer()
                    }
                } else {
                    self.showMessage(message: message)
                }
                
            }) {(error) -> Void in
                self.hideMBProgress()
            }

        } else {
            
            
        }
        
    }
    func sendTextToServer() -> Void {
        var param = ["TokenID":String.readToken()]
        param.updateValue(self.filePath, forKey: "photo")
        param.updateValue("1", forKey: "type")
        param.updateValue(self.textView.textViewTest.text, forKey: "content")
        param.updateValue(String.readToken(), forKey: "TokenID")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: "addAPP"), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let status:String = json["status"] as! String
            let message:String = json["message"] as! String
            self.showMessage(message: message)
            if status == "1"{
                self.dismiss(animated: true, completion: nil)
            }
            
        }) { (error) in
            self.hideMBProgress()
            
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
