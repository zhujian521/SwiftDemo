//
//  HGitemCollectionVC.swift
//  FirstProject
//
//  Created by zhujian on 18/1/24.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import Photos


protocol HGitemCollectionVCDelegate {
    func sendSelectImageCount(imageArr:Array<HGImaageModel>) -> Void
}
class HGitemCollectionVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    //取得的资源结果，用了存放的PHAsset
    var assetsFetchResults:PHFetchResult<AnyObject>!
    //带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    //缩略图大小
    var assetGridThumbnailSize:CGSize!
    //每次最多可选择的照片数量
    var maxSelected:Int!
    
    var collectionView:UICollectionView!
    
    var dataArr = [HGImaageModel]()
    
    var delegate:HGitemCollectionVCDelegate?
    //完成按钮
    var completeButton:HGImageCompleteButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化和重置缓存
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()

        let flowLayout = UICollectionViewFlowLayout();
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 4)/3,
                                 height: (UIScreen.main.bounds.size.width - 4)/3)
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
        
        let scale = UIScreen.main.scale
        let cellSize = CGSize(width: (UIScreen.main.bounds.size.width - 4)/3,
                               height: (UIScreen.main.bounds.size.width - 4)/3)
        assetGridThumbnailSize = CGSize(width: cellSize.width*scale ,
                                        height: cellSize.height*scale)
        let itemCount:Int = (self.assetsFetchResults.count)
        for item in 0..<itemCount {
            let model = HGImaageModel()
            model.selectStates = false
            let asset = self.assetsFetchResults[item]
            //获取缩略图
            model.image = self.PHAssetToUIImage(asset: asset as! PHAsset)
//            self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize,
//                                           contentMode: .aspectFill, options: nil) {
//                                            (image, nfo) in
//            }
            self.dataArr.append(model)
            

            
        }

        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 109), collectionViewLayout: flowLayout);
        collectionView!.backgroundColor = UIColor.white;
        collectionView!.delegate = self;
        collectionView!.dataSource = self;
        self.collectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView!);

        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: kScreenHeight - 109, width: kScreenWidth, height: 60))
        self.view.addSubview(toolBar)
        
        //添加下方工具栏的完成按钮
        completeButton = HGImageCompleteButton()
        completeButton.addTarget(target: self, action: #selector(finishSelect))
        completeButton.center = CGPoint(x: UIScreen.main.bounds.width - 50, y: 22)
        completeButton.isEnabled = false
        toolBar.addSubview(completeButton)

    }
    // MARK: - 将PHAsset对象转为UIImage对象
    func PHAssetToUIImage(asset: PHAsset) -> UIImage {
        var image = UIImage()
        
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        
        // 按照PHImageRequestOptions指定的规则取出图片
        imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize, contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }

    //完成按钮点击
    func finishSelect(){
        var selectImageArr = [HGImaageModel]()
        selectImageArr.removeAll()
        for item:HGImaageModel in self.dataArr {
            if item.selectStates! {
                selectImageArr.append(item)
            }
        }

        self.delegate?.sendSelectImageCount(imageArr: selectImageArr)
        self.dismiss(animated: true, completion: nil)
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    // 获取单元格
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取storyboard里设计的单元格，不需要再动态添加界面元素
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! ImageCollectionViewCell
        let model = self.dataArr[indexPath.row]
        cell.imageView.image = model.image
        cell.deleteButton.isHidden = true
//        cell.setImageSelectStates(model: model)

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = self.selectedCount()
        let model = self.dataArr[indexPath.row]

        if count >= self.maxSelected && !model.selectStates{
            self.showMessage(message: "最多只能选择9张")
            return
        }
        model.selectStates! = !model.selectStates!
        let cell = collectionView.cellForItem(at: indexPath)
            as? ImageCollectionViewCell
        cell?.playAnimate()
        self.collectionView.reloadItems(at: [indexPath])
        completeButton.num = self.selectedCount()
        if self.selectedCount() == 0 {
            completeButton.isEnabled = false
        } else {
            completeButton.isEnabled = true

        }


    }
    //重置缓存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    //获取已选择个数
    func selectedCount() -> Int {
        var selectImageArr = [HGImaageModel]()
        selectImageArr.removeAll()
        for item:HGImaageModel in self.dataArr {
            if item.selectStates! {
                selectImageArr.append(item)
            }
        }
        return selectImageArr.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
