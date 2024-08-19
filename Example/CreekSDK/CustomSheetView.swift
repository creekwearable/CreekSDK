//
//  CustomSheetView.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/3/7.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class CustomSheetView: BaseSheetView ,UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.models.isEmpty{
           return 0
        }else{
           return self.models[selectIndex].typeModels?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Customcell", for: indexPath) as? Customcell
        let isSelect = self.models[selectIndex].selectedIndex == indexPath.row
        let model:DialTypeModel = self.models[selectIndex].typeModels![indexPath.row]
        cell?.setdata(data: model,isBool: isSelect)
        cell?.callBlock = {
            
            var selectIndexs:[Int] = []
            var i = 0
            self.models.forEach { dialFunctionModel in
                if self.selectIndex == i {
                    selectIndexs.append(indexPath.row)
                }else{
                    selectIndexs.append(dialFunctionModel.selectedIndex ?? 0)
                }
                i+=1
            }
            if let back = self.selectTypeBlock{
                back(selectIndexs)
            }
        }
        return cell!
    }
    
    
    lazy var lefttitleLab: UILabel = {
       let lab = UILabel()
       lab.text = "Custom function"
       lab.preferredMaxLayoutWidth = FBScale(70)
       lab.textAlignment = .center
        lab.textColor = UIColor.black
        lab.font = UIFont.init(name: "PingFangSC-Semibold", size: FBScale(72))
       return lab
   }()

    lazy var cannelBut:UIButton = {
        let but = UIButton()
        but.setTitleColor(UIColor.blue, for: .normal)
        but.setTitle("Cancel", for: .normal)
        but.addTarget(self, action: #selector(hideSheetView), for: .touchUpInside)
        return but
    }()
    

    lazy var backgroundView:ZBSlideBackgroundView = {
        let aview = ZBSlideBackgroundView()
        return aview
    }()
    
    lazy var tableView:UITableView = {
        let tab = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tab.delegate = self
        tab.dataSource = self
        tab.estimatedRowHeight = 44
        tab.estimatedSectionHeaderHeight = 0
        tab.estimatedSectionFooterHeight = 0
        tab.showsVerticalScrollIndicator = false
        tab.showsHorizontalScrollIndicator = false
        tab.backgroundColor = UIColor.clear
        tab.separatorStyle = UITableViewCell.SeparatorStyle.none
        tab.separatorColor = UIColor.clear
        tab.register(Customcell.self, forCellReuseIdentifier: "Customcell")
        return tab
    }()
    
    
    var models:[DialFunctionModel] = []
    var selectIndex = 0
    
    var height = FBScale(448)
    var width = FBScale(368)
    var cornerRadius = FBScale(60)
    
    var selectTypeBlock: ((_ selectIndex:[Int])->())?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        
    }
    
    func layoutUI(){
        contentView.addSubview(lefttitleLab)
        contentView.addSubview(cannelBut)
        contentView.addSubview(backgroundView)
        contentView.addSubview(tableView)
        
        
        
        lefttitleLab.snp.makeConstraints {
            $0.left.equalTo(FBScale(40))
            $0.top.equalTo(FBScale(20))
            $0.width.height.greaterThanOrEqualTo(0)
        }
        
        cannelBut.snp.makeConstraints {
            $0.right.equalTo(-FBScale(40))
            $0.top.equalTo(FBScale(20))
            $0.width.equalTo(FBScale(200))
            $0.height.equalTo(FBScale(60))
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(lefttitleLab.snp.bottom).offset(FBScale(60))
            $0.height.equalTo(FBScale(600))
            $0.left.right.equalTo(contentView)
        }
        tableView.snp.makeConstraints {
            $0.left.right.equalTo(contentView)
            $0.top.equalTo(backgroundView.snp.bottom).offset(FBScale(40))
            $0.bottom.equalTo(contentView.snp.bottom).offset(-FBScale(60))
        }
        
        
    }
    
    func setData(models:[DialFunctionModel]){
        self.models = models
        let arr:[String] = models.map { model in
            return model.positionImage ?? ""
        }
        backgroundView.height = height
        backgroundView.width = width
        backgroundView.cornerRadius = cornerRadius
        backgroundView.itemsTitle = arr
       backgroundView.slideBarItemSelected(index: self.selectIndex)
        backgroundView.callback = {
            self.selectIndex = $0
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Customcell: UITableViewCell {
    
    lazy var nameLab: UILabel = {
       let lab = UILabel()
       lab.text = "sport"
       lab.preferredMaxLayoutWidth = FBScale(70)
       lab.textAlignment = .center
        lab.textColor = UIColor.black
        lab.font = UIFont.init(name: "PingFangSC-Regular", size: FBScale(28))
       return lab
   }()
    
    lazy var leftImage: UIImageView = {
       let aimge = UIImageView()
        aimge.backgroundColor = UIColor.gray
       return aimge
   }()
    
    lazy var rightImage: UIImageView = {
       let aimge = UIImageView()
        aimge.image = UIImage(named: "select_icon")
        aimge.isHidden = true
       return aimge
   }()
    
    var callBlock: (()->())?
    
    
    //分割线
    private lazy var smalllineView: UILabel = {
        let lab = UILabel()
        lab.backgroundColor =  UIColor(red: 244/255.0, green: 246/255.0, blue: 247/255.0, alpha: 1.00)
        return lab
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tap)
        layoutUI()
    }
    
   @objc func tapClick(){
       if let back = self.callBlock{
           back()
       }
    }
    
    func layoutUI(){
        contentView.addSubview(nameLab)
        contentView.addSubview(leftImage)
        contentView.addSubview(rightImage)
        contentView.addSubview(smalllineView)
        leftImage.snp.makeConstraints {
            $0.left.equalTo(FBScale(40))
            $0.top.equalTo(FBScale(20))
            $0.width.height.equalTo(FBScale(80))
        }
        nameLab.snp.makeConstraints{
            $0.left.equalTo(leftImage.snp.right).offset(FBScale(40))
            $0.width.height.greaterThanOrEqualTo(0)
            $0.centerY.equalTo(leftImage)
        }
        rightImage.snp.makeConstraints {
            $0.right.equalTo(contentView.snp.right).offset(-FBScale(40))
            $0.centerY.equalTo(leftImage)
            $0.width.height.equalTo(FBScale(80))
        }
        smalllineView.snp.makeConstraints {
            $0.left.equalTo(FBScale(20))
            $0.right.equalTo(-FBScale(20))
            $0.top.equalTo(leftImage.snp.bottom).offset(FBScale(20))
            $0.height.equalTo(1)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func setdata(data:DialTypeModel,isBool:Bool) {
        nameLab.text = data.type
        leftImage.image = UIImage(contentsOfFile: data.image ?? "")
        rightImage.isHidden = !isBool
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


