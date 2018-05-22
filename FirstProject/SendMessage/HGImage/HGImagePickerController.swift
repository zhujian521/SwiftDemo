//
//  HGImagePickerController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/24.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import Photos

//相簿列表项
class AlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源集合
    var fetchResult: PHFetchResult<AnyObject>
    
    init(title:String?,fetchResult:PHFetchResult<AnyObject>){
        self.title = title
        self.fetchResult = fetchResult
    }
}

protocol HGImagePickerControllerDelegate {
    func ImagePickerFinish(imageArr:Array<HGImaageModel>) -> Void
}
class HGImagePickerController: BaseViewController ,UITableViewDelegate,UITableViewDataSource,AlbumItemControllerDelegate{
    //相簿列表项集合
    var items:[AlbumItem] = [AlbumItem]()
    //每次最多可选择的照片数量
    var maxSelected:Int!
    var tableView:UITableView?
    var delegate:HGImagePickerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置标题
        title = "相簿"
        //添加导航栏右侧的取消按钮
        let rightBarItem = UIBarButtonItem(title: "取消", style: .plain, target: self,
                                           action:#selector(cancel) )
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.creatTableView()
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            return
        }
        // 列出所有系统的智能相册
        let smartOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: PHAssetCollectionSubtype.albumRegular,
                                                                  options: smartOptions)
        self.convertCollection(collection: smartAlbums as! PHFetchResult<AnyObject>)
        
        //列出所有用户创建的相册
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        self.convertCollection(collection: userCollections as! PHFetchResult<AnyObject>)
        
        //相册按包含的照片数量排序
        self.items.sort { (item1, item2) -> Bool in
            return item1.fetchResult.count > item2.fetchResult.count
        }


    }
    func creatTableView() -> Void {
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.view.frame.size.height))
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView?.backgroundColor = UIColor.clear
        self.tableView?.register(UINib.init(nibName: "HGImagePickerCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
        
    }
    func cancel() -> Void {
        self.dismiss(animated: true, completion: nil)

    }
   override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //转化处理获取到的相簿
    private func convertCollection(collection:PHFetchResult<AnyObject>){
        
        for i in 0..<collection.count{
            //获取出相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            guard let c = collection[i] as? PHAssetCollection else { return }
            let assetsFetchResult = PHAsset.fetchAssets(in: c ,
                                                        options: resultsOptions)
            //没有图片的空相簿不显示
            if assetsFetchResult.count > 0{
//                var imageArr:[UIImage] = [UIImage]()
//                for item in 0..<assetsFetchResult.count {
//                   let tempImage = self.PHAssetToUIImage(asset: assetsFetchResult[item])
//                    imageArr.append(tempImage)
//
//                }
//                print("=====\(imageArr)")
                items.append(AlbumItem(title: c.localizedTitle, fetchResult: assetsFetchResult as! PHFetchResult<AnyObject>))
            }
        }
        
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
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }

    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell:HGImagePickerCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HGImagePickerCell
            cell.selectionStyle = .none
            let item = self.items[indexPath.row]
            cell.AlbumText.text = "\(item.title ?? "") "
            cell.AlbumCont.text = "（\(item.fetchResult.count)）"
            return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("===============%d",indexPath.row)
            //获取选中的相簿信息
            let fetchResult = self.items[indexPath.row].fetchResult
            let titleLabel = self.items[indexPath.row].title
            let vc = AlbumItemController()
            vc.assetsFetchResults = fetchResult
            vc.title = titleLabel
            vc.delegate = self
            vc.maxSelected = self.maxSelected
            self.navigationController?.pushViewController(vc, animated: true)



    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func sendSelectImageCount(imageArr: Array<HGImaageModel>) {
        self.delegate?.ImagePickerFinish(imageArr: imageArr)
    }


    

}

