//
//  AlbumItemController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/30.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import Photos
protocol AlbumItemControllerDelegate {
    func sendSelectImageCount(imageArr:Array<HGImaageModel>) -> Void
}

class AlbumItemController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    //取得的资源结果，用了存放的PHAsset
    var assetsFetchResults:PHFetchResult<AnyObject>!
    //带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    //缩略图大小
    var assetGridThumbnailSize:CGSize!
    //每次最多可选择的照片数量
    var maxSelected:Int!
  
    var collectionView:UICollectionView!
    
    
    var delegate:AlbumItemControllerDelegate?
    //完成按钮
    var completeButton:HGImageCompleteButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        print(assetsFetchResults)
        
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 109), collectionViewLayout: flowLayout);
        collectionView!.backgroundColor = UIColor.white;
        collectionView!.delegate = self;
        collectionView!.dataSource = self;
        collectionView.allowsMultipleSelection = true
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
    //重置缓存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    func finishSelect() -> Void {
        var dataArr = [HGImaageModel]()
        if let indexPaths = self.collectionView.indexPathsForSelectedItems{
            for indexPath in indexPaths{
//                let cell = collectionView.cellForItem(at: indexPath)
//                    as? ImageCollectionViewCell
//                print("\(cell?.imageView.image)")
                let model = HGImaageModel()
                model.selectStates = false
//                model.image = cell?.imageView.image
                model.image = self.PHAssetToMaxUIImage(asset: self.assetsFetchResults[indexPath.row] as! PHAsset)
                dataArr.append(model)

            }
        }
        self.delegate?.sendSelectImageCount(imageArr: dataArr)
        self.dismiss(animated: true, completion: nil)

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
        imageRequestOption.deliveryMode = .fastFormat
        
        // 按照PHImageRequestOptions指定的规则取出图片 PHImageManagerMaximumSize
        print("\(PHImageManagerMaximumSize)")
        imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize, contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }
    func PHAssetToMaxUIImage(asset: PHAsset) -> UIImage {
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
        imageRequestOption.deliveryMode = .fastFormat
        
        // 按照PHImageRequestOptions指定的规则取出图片 PHImageManagerMaximumSize
        print("\(PHImageManagerMaximumSize)")
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults.count
    }
    // 获取单元格
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! ImageCollectionViewCell
        let asset = self.assetsFetchResults![indexPath.row]
        cell.imageView.image = self.PHAssetToUIImage(asset: asset as! PHAsset)
        
        cell.deleteButton.isHidden = true

        return cell
    }
    //单元格选中响应
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath)
            as? ImageCollectionViewCell{
            //获取选中的数量
            let count = self.selectedCount()
            //如果选择的个数大于最大选择数
            if count > self.maxSelected {
                //设置为不选中状态
                collectionView.deselectItem(at: indexPath, animated: false)
                //弹出提示
                let title = "你最多只能选择\(self.maxSelected!)张照片"
                let alertController = UIAlertController(title: title, message: nil,
                                                        preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title:"我知道了", style: .cancel,
                                                 handler:nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
                //如果不超过最大选择数
            else{
                //改变完成按钮数字，并播放动画
                completeButton.num = count
                if count > 0 && !self.completeButton.isEnabled{
                    completeButton.isEnabled = true
                }
                cell.playAnimate()
            }
        }

    }
    //单元格取消选中响应
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        
    }
    //获取已选择个数
    func selectedCount() -> Int {
        return self.collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
