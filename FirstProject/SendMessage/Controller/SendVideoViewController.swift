//
//  SendVideoViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/27.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AVKit

typealias saveButtonClose = (_ saveImage:UIImage,_ saveURL:URL)->Void
class SendVideoViewController: BaseViewController {
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    let captureSession = AVCaptureSession()
    //视频输入设备
    let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    //音频输入设备
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    //将捕获到的视频输出到文件
    let fileOutput = AVCaptureMovieFileOutput()
    
    //录制、保存 ,返回按钮
    var recordButton, saveButton ,backButton,againButton: UIButton!
    //保存所有的录像片段数组
    var videoAssets = [AVAsset]()
    //保存所有的录像片段url数组
    var assetURLs = [String]()
    //单独录像片段的index索引
    var appendix: Int32 = 1
    //播放器
    var player :AVPlayer?
    var playerItem:AVPlayerItem?
    //播放器layer
    var playerLayer:AVPlayerLayer?
    //完成后的avseet
    var Asset : AVURLAsset?
    
    
    //最大允许的录制时间（秒）
    let totalSeconds: Float64 = 9.00
    //每秒帧数
    var framesPerSecond:Int32 = 30
    //剩余时间
    var remainingTime : TimeInterval = 9.0
    
    //表示是否停止录像
    var stopRecording: Bool = false
    //剩余时间计时器
    var timer: Timer?
    //进度条计时器
    var progressBarTimer: Timer?
    //进度条计时器时间间隔
    var incInterval: TimeInterval = 0.05
    //进度条
    var progressBar: UIView = UIView()
    //当前进度条终点位置
    var oldX: CGFloat = 0
    //视频完成后保存的URL
    var saveURL : URL?
    //视频完成后保存的第一帧的图片
    var saveImage:UIImage?
    //完成按钮的闭包
    var saveClose : saveButtonClose?
    
    func setSaveButtonClickClose(mySaveClose : @escaping saveButtonClose)->Void {
        self.saveClose = mySaveClose
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        //添加视频、音频输入设备
        let videoInput = try? AVCaptureDeviceInput(device: self.videoDevice)
        self.captureSession.addInput(videoInput)
        let audioInput = try? AVCaptureDeviceInput(device: self.audioDevice)
        self.captureSession.addInput(audioInput)
        
        //添加视频捕获输出
        let maxDuration = CMTimeMakeWithSeconds(totalSeconds, framesPerSecond)
        self.fileOutput.maxRecordedDuration = maxDuration
        self.captureSession.addOutput(self.fileOutput)
        
        //使用AVCaptureVideoPreviewLayer可以将摄像头的拍摄的实时画面显示在ViewController上
        if let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession) {
            videoLayer.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height-100)
            videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.view.layer.addSublayer(videoLayer)
        }
        
        //创建按钮
        self.setupButton()
        //启动session会话
        self.captureSession.startRunning()
        
        //添加进度条
        progressBar.frame = CGRect(x: 0, y: self.view.bounds.size.height-100, width: self.view.bounds.width,height: 3)
        progressBar.isHidden = false
        progressBar.backgroundColor = UIColor(red: 4, green: 3, blue: 3, alpha: 0.5)
        self.view.addSubview(progressBar)
        

    }
    //创建按钮
    func setupButton(){
        //创建录制按钮
        self.recordButton = UIButton(frame: CGRect(x:0,y:0,width:74,height:74))
        self.recordButton.layer.masksToBounds = true
//        self.recordButton.setImage(UIImage.init(named: "拍摄"), for: .normal)
        self.recordButton.backgroundColor = UIColor.red
        self.recordButton.layer.cornerRadius = 37.0
        self.recordButton.isHidden = false
        self.recordButton.layer.position = CGPoint(x: self.view.bounds.width/2,
                                                   y:self.view.bounds.height-50)
        self.recordButton.addTarget(self, action: #selector(onTouchDownRecordButton(_:)),
                                    for: .touchDown)
        self.recordButton.addTarget(self, action: #selector(onTouchUpRecordButton(_:)),
                                    for: .touchUpInside)
        
        //创建保存按钮
        self.saveButton = UIButton(frame: CGRect(x:0,y:0,width:74,height:74))
        self.saveButton.layer.masksToBounds = true
        self.saveButton.setImage(UIImage.init(named: "CellBlueSelected"), for: .normal)
        self.saveButton.backgroundColor = UIColor.white
        self.saveButton.layer.cornerRadius = 37.0
        self.saveButton.isHidden = true
        self.saveButton.layer.position = CGPoint(x: self.view.bounds.width - 60,
                                                 y:self.view.bounds.height-50)
        self.saveButton.addTarget(self, action: #selector(onClickStopButton(_:)),
                                  for: .touchUpInside)
        //创建返回
        self.backButton = UIButton(frame: CGRect(x:0,y:0,width:44,height:44))
        self.backButton.layer.masksToBounds = true
        self.backButton.layer.position = CGPoint(x: 60,
                                                 y:self.view.bounds.height-50)
        self.backButton.setImage(UIImage.init(named: "down"), for: .normal)
        self.backButton.isHidden = false
        self.backButton.addTarget(self, action: #selector(onClickBackButton(_:)),
                                  for: .touchUpInside)
        
        //创建重拍
        self.againButton = UIButton(frame: CGRect(x:0,y:0,width:74,height:74))
        self.againButton.layer.masksToBounds = true
        self.againButton.layer.position = CGPoint(x: 60,
                                                  y:self.view.bounds.height-50)
        self.againButton.isHidden = true
        self.againButton.backgroundColor = UIColor.white
        self.againButton.setImage(UIImage.init(named: "goBack"), for: .normal)
        
        self.againButton.layer.cornerRadius = 37.0
        self.againButton.addTarget(self, action: #selector(onClickAgainButton(_:)),
                                   for: .touchUpInside)
        
        //添加按钮到视图上
        self.view.addSubview(self.recordButton)
        self.view.addSubview(self.saveButton)
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.againButton)
    }
    //MARK:按钮点击处理
    //按下录制按钮，开始录制片段
    func  onTouchDownRecordButton(_ sender: UIButton){
        if(!stopRecording) {
            let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                            .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let outputFilePath = "\(documentsDirectory)/output-\(appendix).mov"
            appendix += 1
            let outputURL = URL(fileURLWithPath: outputFilePath)
            let fileManager = FileManager.default
            if(fileManager.fileExists(atPath: outputFilePath)) {
                
                do {
                    try fileManager.removeItem(atPath: outputFilePath)
                } catch _ {
                }
            }
            print("开始录制：\(outputFilePath) ")
            fileOutput.startRecording(toOutputFileURL: outputURL,
                                      recordingDelegate: self)
        }
    }
    //松开录制按钮，停止录制片段
    func  onTouchUpRecordButton(_ sender: UIButton){
        if(!stopRecording) {
            timer?.invalidate()
            progressBarTimer?.invalidate()
            fileOutput.stopRecording()
        }
    }
    //返回按钮
    func  onClickBackButton(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    //保存按钮点击
    func onClickStopButton(_ sender: UIButton){
        print("\(self.saveImage)==\(self.saveURL)")
        self.saveClose!(self.saveImage!,self.saveURL!)
        self.dismiss(animated: true, completion: nil)
    }
    //重拍按钮
    func  onClickAgainButton(_ sender:UIButton){
        self.saveButton.isHidden = true
        self.progressBar.isHidden = false
        self.recordButton.isHidden = false
        self.backButton.isHidden = false
        self.againButton.isHidden = true
        self.playerLayer?.removeFromSuperlayer()
        self.player?.pause()
        self.reset()
        self.player = nil
    }
    //MARK:计时器
    //剩余时间计时器
    func startTimer() {
        timer = Timer(timeInterval: remainingTime, target: self,
                      selector: #selector(SendVideoViewController.timeout), userInfo: nil,
                      repeats:true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    //录制时间达到最大时间
    func timeout() {
        stopRecording = true
        print("时间到。")
        fileOutput.stopRecording()
        timer?.invalidate()
        progressBarTimer?.invalidate()
    }
    
    //进度条计时器
    func startProgressBarTimer() {
        progressBarTimer = Timer(timeInterval: incInterval, target: self,
                                 selector: #selector(SendVideoViewController.progress),
                                 userInfo: nil, repeats: true)
        RunLoop.current.add(progressBarTimer!, forMode: .defaultRunLoopMode)
    }
    
    //修改进度条进度
    func progress() {
        let progressProportion: CGFloat = CGFloat(incInterval / totalSeconds)
        let progressInc: UIView = UIView()
        progressInc.backgroundColor = UIColor(red: 55/255, green: 186/255, blue: 89/255,
                                              alpha: 1)
        let newWidth = progressBar.frame.width * progressProportion
        progressInc.frame = CGRect(x: oldX , y: 0, width: newWidth,
                                   height: progressBar.frame.height)
        oldX = oldX + newWidth
        progressBar.addSubview(progressInc)
    }
    
    //合并视频片段 断点续传
    func mergeVideos() {
        //   let duration = totalSeconds
        
        //        let composition = AVMutableComposition()
        //        //合并视频、音频轨道
        //        let firstTrack = composition.addMutableTrack(
        //            withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        //        let audioTrack = composition.addMutableTrack(
        //            withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        //
        //        var insertTime: CMTime = kCMTimeZero
        //        for asset in videoAssets {
        //            print("合并视频片段：\(asset)")
        //            do {
        //                try firstTrack.insertTimeRange(
        //                    CMTimeRangeMake(kCMTimeZero, asset.duration),
        //                    of: asset.tracks(withMediaType: AVMediaTypeVideo)[0] ,
        //                    at: insertTime)
        //            } catch _ {
        //            }
        //            do {
        //                try audioTrack.insertTimeRange(
        //                    CMTimeRangeMake(kCMTimeZero, asset.duration),
        //                    of: asset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
        //                    at: insertTime)
        //            } catch _ {
        //            }
        //
        //            insertTime = CMTimeAdd(insertTime, asset.duration)
        //        }
        //        //旋转视频图像，防止90度颠倒
        //        firstTrack.preferredTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        
        //裁剪视频区域
        
        //        //定义最终生成的视频尺寸（矩形的）
        //        print("视频原始尺寸：", firstTrack.naturalSize)
        //        let renderSize = CGSize.init(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        //        print("最终渲染尺寸：", renderSize)
        //
        //        //通过AVMutableVideoComposition实现视频的裁剪(矩形，截取正中心区域视频)
        //        let videoComposition = AVMutableVideoComposition()
        //        videoComposition.frameDuration = CMTimeMake(1, framesPerSecond)
        //        videoComposition.renderSize = renderSize
        //
        //        let instruction = AVMutableVideoCompositionInstruction()
        //        instruction.timeRange = CMTimeRangeMake(
        //            kCMTimeZero,CMTimeMakeWithSeconds(Float64(duration), framesPerSecond))
        //
        //        let transformer: AVMutableVideoCompositionLayerInstruction =
        //            AVMutableVideoCompositionLayerInstruction(assetTrack: firstTrack)
        //        let t1 = CGAffineTransform(translationX: firstTrack.naturalSize.height,
        //                                   y: 0)
        //        let t2 = t1.rotated(by: CGFloat(M_PI_2))
        //        let finalTransform: CGAffineTransform = t2
        //        transformer.setTransform(finalTransform, at: kCMTimeZero)
        //
        //        instruction.layerInstructions = [transformer]
        //        videoComposition.instructions = [instruction]
        //获取合并后的视频路径
        let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                .userDomainMask,true)[0]
        let destinationPath = documentsPath + "/mergeVideo-\(arc4random()%1000).mov"
        print("合并后的视频：\(destinationPath)")
        let videoPath = URL(fileURLWithPath: destinationPath as String)
        //        let exporter = AVAssetExportSession(asset: composition,
        //                                            presetName:AVAssetExportPresetHighestQuality)!
        let exporter = AVAssetExportSession(asset: self.Asset!,
                                            presetName:AVAssetExportPresetMediumQuality)!
        
        exporter.outputURL = videoPath
        self.saveURL = videoPath
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        exporter.shouldOptimizeForNetworkUse = true
        // exporter.videoComposition = videoComposition
        // exporter.timeRange = CMTimeRangeMake(
        //    kCMTimeZero,CMTimeMakeWithSeconds(Float64(duration), framesPerSecond))
        exporter.timeRange = CMTimeRangeMake(
            kCMTimeZero, self.Asset!.duration)
        exporter.exportAsynchronously(completionHandler: {
            //将合并后的视频保存到相册
            DispatchQueue.main.async {
                var duration : TimeInterval = 0.0
                duration = CMTimeGetSeconds(self.Asset!.duration)
                if duration < 1{
                    print("视频太短了")
                    self.onClickAgainButton(self.againButton)
                }else{
                    self.saveButton.isHidden = false
                    self.progressBar.isHidden = true
                    self.recordButton.isHidden = true
                    self.backButton.isHidden = true
                    self.againButton.isHidden = false
                    self.reviewRecord(outputURL: videoPath)
                    self.exportDidFinish(session: exporter)
                }
            }
        })
    }
    //将合并后的视频保存到相册
    func exportDidFinish(session: AVAssetExportSession) {
        print("视频合并成功！")
        let outputURL = session.outputURL!
        //将录制好的录像保存到照片库中
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            DispatchQueue.main.async {
                //重置参数
                self.reset()
                // self.reviewRecord(outputURL: outputURL)
            }
        })
    }
    //视频保存成功，重置各个参数，准备新视频录制
    func reset() {
        //删除视频片段
        for assetURL in assetURLs {
            if(FileManager.default.fileExists(atPath: assetURL)) {
                do {
                    try FileManager.default.removeItem(atPath: assetURL)
                } catch _ {
                }
                print("删除视频片段: \(assetURL)")
            }
        }
        
        //进度条还原
        let subviews = progressBar.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        //各个参数还原
        videoAssets.removeAll(keepingCapacity: false)
        assetURLs.removeAll(keepingCapacity: false)
        appendix = 1
        oldX = 0
        stopRecording = false
        remainingTime = totalSeconds
    }
    //录像回看
    func reviewRecord(outputURL: URL) {
        //定义一个视频播放器，通过本地文件路径初始化
        let playerItem = AVPlayerItem(url: outputURL)
        self.player = AVPlayer(playerItem: playerItem)
        self.playerItem = playerItem
        let playerLayer = AVPlayerLayer(player: player)
        self.playerLayer = playerLayer
        playerLayer.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.view.layer.insertSublayer(playerLayer, at: 1)
        self.player?.play()
        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: .AVPlayerItemDidPlayToEndTime, object: self.playerItem)
    }
    func loopVideo()  {
        self.player?.seek(to:kCMTimeZero)
        self.player?.play()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension SendVideoViewController :AVCaptureFileOutputRecordingDelegate{
    //录像开始的代理方法
    func capture(_ captureOutput: AVCaptureFileOutput!,
                 didStartRecordingToOutputFileAt fileURL: URL!,
                 fromConnections connections: [Any]!) {
        startProgressBarTimer()
        startTimer()
    }
    
    //录像结束的代理方法
    func capture(_ captureOutput: AVCaptureFileOutput!,
                 didFinishRecordingToOutputFileAt outputFileURL: URL!,
                 fromConnections connections: [Any]!, error: Error!) {
        let asset = AVURLAsset(url: outputFileURL, options: nil)
        var duration : TimeInterval = 0.0
        duration = CMTimeGetSeconds(asset.duration)
        print("生成视频片段：\(asset)")
        videoAssets.append(asset)
        assetURLs.append(outputFileURL.path)
        remainingTime = remainingTime - duration
        self.Asset = asset
        //到达允许最大录制时间，自动合并视频
        //if remainingTime <= 0 {
        mergeVideos()
        // }
        //生成视频截图
        if duration > 1 {
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(0.0,100)
            var actualTime:CMTime = CMTimeMake(0,0)
            let imageRef:CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
            let frameImg = UIImage(cgImage: imageRef)
            self.saveImage = frameImg
        }else{
            print("视频太短")
        }
        
    }
}

