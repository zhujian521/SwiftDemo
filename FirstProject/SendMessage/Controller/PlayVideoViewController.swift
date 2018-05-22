//
//  PlayVideoViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/31.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class PlayVideoViewController: BaseViewController {
    var URL : URL?
    //播放器
    var player :AVPlayer?
    var playerItem:AVPlayerItem?
    //播放器layer
    var playerLayer:AVPlayerLayer?
    //完成后的avseet
    var Asset : AVURLAsset?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "录像回放"
        self.reviewRecord(outputURL: self.URL!)

    }
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
