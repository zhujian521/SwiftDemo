//
//  PlateViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/3/9.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class PlateViewController: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    var subTitles = [String]()
    var subUrls = [String]()
    var addTitlesModel = [MyForumModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let backButton = UIButton.init(frame: CGRect.init(x: 10, y: 20, width: 44, height: 44))
        self.view.addSubview(backButton)
        backButton.setTitle("返回", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.addTarget(self, action: #selector(handleDissMissAction), for: .touchUpInside)
        self.creatCollectionView()
        
    }
    func handleDissMissAction() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    func creatCollectionView() -> Void {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: (SCREEN_WIDTH - 4) / 4, height: (SCREEN_WIDTH - 4) / 6)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize.init(width: SCREEN_WIDTH , height: 40)
        layout.footerReferenceSize = CGSize.init(width: 0, height: 0)
        layout.scrollDirection = .vertical
        let myCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64), collectionViewLayout: layout)
        myCollectionView.delegate = self
        myCollectionView.backgroundColor = UIColor.white
        myCollectionView.dataSource = self
        myCollectionView.register(UINib.init(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    
        myCollectionView.register(UINib.init(nibName: "HeadTitleCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        
        
        self.view.addSubview(myCollectionView)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.subTitles.count
        }
        return self.addTitlesModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ListCollectionViewCell
        if indexPath.section == 0 {
            cell.listName.text = self.subTitles[indexPath.row]
            if indexPath.row == 0 || indexPath.row == 1 {
                cell.deleteButton.isHidden = true

            } else {
                cell.deleteButton.isHidden = false

                
            }
        } else {
            let model:MyForumModel = self.addTitlesModel[indexPath.row]
            cell.deleteButton.isHidden = true
            cell.listName.text = model.fName
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == "UICollectionElementKindSectionHeader"{
            let resuableView:HeadTitleCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header", for: indexPath) as! HeadTitleCollectionReusableView
            if indexPath.section == 0 {
                resuableView.headTitle.text = "我的关注"
            } else {
                resuableView.headTitle.text = "添加关注"

            }
            return resuableView
        }else{
            let resuableView = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "footer", for: indexPath) as! HeadTitleCollectionReusableView
            return resuableView
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
