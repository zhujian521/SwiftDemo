//
//  UpLoadVideoVC.swift
//  FirstProject
//
//  Created by zhujian on 18/1/31.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import MobileCoreServices
import AssetsLibrary
import AVKit
import MediaPlayer


class UpLoadVideoVC: BaseViewController {
    var tempImage:UIImage? = nil
    var URL : URL?
    var textView:CustomTextView!
    var filePath:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布视频"
        self.view.backgroundColor = UIColor.white
        let textView = CustomTextView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 150))
        self.textView = textView
        self.view.addSubview(textView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -10;
        self.navigationItem.rightBarButtonItems = [spacer,CustomBarButton.creatTextBarbuttonItem(name: "确定", target: self, action: #selector(handleSure))]
        self.creatImage()

    }
    func creatImage() -> Void {
        let tempImage = UIImageView.init(frame: CGRect.init(x: 10, y: 150, width: 100, height: 100))
        tempImage.layer.masksToBounds = true
        tempImage.contentMode = .scaleAspectFill
        tempImage.isUserInteractionEnabled = true
        self.view.addSubview(tempImage)
        tempImage.image = self.tempImage
        
        let playBtn = UIButton.init(frame: CGRect.init(x: 30, y: 30, width: 40, height: 40))
        playBtn.setImage(UIImage.init(named: "play"), for: .normal)
        playBtn.addTarget(self, action: #selector(handlePlay( _ : )), for: .touchUpInside)
        tempImage.addSubview(playBtn)
    }
    func handleSure() -> Void {
        self.view.endEditing(true)
        if self.textView.textViewTest.text.isEmpty {
            self.showMessage(message: "请输入文字")
            return
        }
        let outpath = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).mp4"
        self.transformMoive(inputPath: (self.URL?.path)!, outputPath: outpath)

//        self.uploadVideo(mp4Path: self.URL!)
        
        
    }
    func handlePlay(_ sender:UIButton) -> Void {
        let vc = PlayVideoViewController()
        vc.URL = self.URL
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func transformMoive(inputPath:String,outputPath:String){
        
            let avAsset:AVURLAsset = AVURLAsset(url: NSURL.init(fileURLWithPath: inputPath) as URL, options: nil)
            let assetTime = avAsset.duration
        
            let duration = CMTimeGetSeconds(assetTime)
            print("视频时长 \(duration)");
            let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: avAsset)
            if compatiblePresets.contains(AVAssetExportPresetLowQuality) {
                let exportSession:AVAssetExportSession = AVAssetExportSession.init(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)!
                let existBool = FileManager.default.fileExists(atPath: outputPath)
                if existBool {
                }
                exportSession.outputURL = NSURL.init(fileURLWithPath: outputPath) as URL
                
                
                exportSession.outputFileType = AVFileTypeMPEG4
                exportSession.shouldOptimizeForNetworkUse = true;
                exportSession.exportAsynchronously(completionHandler: {
                    
                    switch exportSession.status{
                        
                    case .failed:
                        
                        print("失败...\(String(describing: exportSession.error?.localizedDescription))")
                        break
                    case .cancelled:
                        print("取消")
                        break;
                    case .completed:
                        print("转码成功")
                        let mp4Path = NSURL.init(fileURLWithPath: outputPath)
                        print("====\(mp4Path)")
                        self.uploadVideo(mp4Path: mp4Path as URL)
                        break;
                    default:
                        print("..")
                        break;
                    }
                })
            }
        }
//    }
    //上传视频到服务器
    func uploadVideo(mp4Path : URL){
    
        let uploadURL = "http://120.77.211.200/image/upload"
//        self.showMBProgress()
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let str = formatter.string(from: NSDate.init() as Date)
        let fileName = str + ".mp4"
        Alamofire.upload(
            //同样采用post表单上传 video/mp4
            multipartFormData: { multipartFormData in
                multipartFormData.append( (String.readToken().data(using: String.Encoding.utf8)!), withName: "TokenID")
                multipartFormData.append(mp4Path, withName: "pictureFile", fileName: fileName, mimeType: "video/mp4")
        
        },to: uploadURL,encodingCompletion: { encodingResult in
//            self.hideMBProgress()
            switch encodingResult {
            case .success(let upload, _, _):
                //json处理
                upload.responseJSON { response in
                    //解包
                    guard let result = response.result.value else { return }
                    print("json:\(result)")
                    let jsonDic = JSON(result)
                    let status:String = jsonDic["status"].stringValue
                    let message:String = jsonDic["message"].stringValue
                    if status == "1"{
                        self.filePath = jsonDic["filePath"].stringValue
                        self.sendTextToServer()
                    } else {
                        self.showMessage(message: message)
                    }


                }
                //上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("视频上传进度: \(progress.fractionCompleted)")
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    func sendTextToServer() -> Void {
        var param = ["TokenID":String.readToken()]
        param.updateValue(self.filePath, forKey: "photo")
        param.updateValue("2", forKey: "type")
        param.updateValue(self.textView.textViewTest.text, forKey: "content")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: "addAPP"), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let status:String = json["status"] as! String
            let message:String = json["message"] as! String
            self.showMessage(message: message)
            if status == "1"{
                self.navigationController?.popViewController(animated: true)
            }
            
        }) { (error) in
            self.hideMBProgress()
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  }
