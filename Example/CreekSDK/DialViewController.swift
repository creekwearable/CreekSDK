//
//  DialViewController.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/1/29.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class DialViewController: CreekBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DialCell
        cell?.selectionStyle = .none
        cell?.setData(data: dic[indexPath.row],type: indexPath.row)
        cell?.tapClick = {(imageName) in
            let vc = DialDetailsViewController()
            if(indexPath.row == 0){
                vc.width = 368
                vc.height = 448
                vc.cornerRadius = 60
            }else{
             
                vc.width = 466
                vc.height = 466
                vc.cornerRadius = 233
            }
            vc.titleName = imageName
            vc.aimageView.image = UIImage(named: imageName)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    lazy var tableView:UITableView = {
        let tab = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tab.delegate = self
        tab.dataSource = self
        tab.estimatedRowHeight = 44
        tab.estimatedSectionHeaderHeight = 0
        tab.estimatedSectionFooterHeight = 0
        tab.showsVerticalScrollIndicator = false
        tab.showsHorizontalScrollIndicator = false
        tab.backgroundColor = .darkGray
        tab.separatorStyle = UITableViewCell.SeparatorStyle.none
        tab.separatorColor = UIColor.clear
        tab.register(DialCell.self, forCellReuseIdentifier: "cell")
        return tab
    }()
    
    
    let dic:[[String:Any]] = [["name":"Square watch","images":["acti06_2","func6_pink","CASIO01_01"]],["name":"Round watch","images":["Fun061101_03","Fun_061211_05_2","Act06_1201_03","CW06G_TITAD101_01"]]]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setRight()
        self.title = "dial"
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.left.right.equalTo(self.view)
            $0.bottom.equalTo(self.view).offset(-SAFEAREAINSETS.bottom)
        }
    }
    func setRight(){
        let but = UIButton(type: .custom)
        but.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        but.setTitleColor(.black, for: .normal)
        but.setTitle("photo", for: .normal)
        but.addTarget(self, action: #selector(tapClick), for: .touchUpInside)
        let itemmeunbut = UIBarButtonItem.init(customView: but)
      
        let but2 = UIButton(type: .custom)
        but2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        but2.setTitleColor(.black, for: .normal)
        but2.setTitle("video", for: .normal)
        but2.addTarget(self, action: #selector(videoClick), for: .touchUpInside)
        let itemmeunbut2 = UIBarButtonItem.init(customView: but2)
        self.navigationItem.rightBarButtonItems = [itemmeunbut,itemmeunbut2]
    }
    
    

    @objc func tapClick()  {
        let vc = DialPhotoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
   @objc func videoClick()  {
      let vc = DialVideoViewController()
       self.navigationController?.pushViewController(vc, animated: true)
   }
    
    
    func isDirectoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
    


}


class DialCell:UITableViewCell{
    
    lazy var slideBackgroundView:ZBSlideBackgroundView = {
        let aview = ZBSlideBackgroundView()
        aview.isLocal = true
        aview.isSelectType = false
        return aview
    }()
    
    var  tapClick:((_ imageName:String)->())?
    var modelJson:[String:Any] = [:]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI(){
        contentView.addSubview(slideBackgroundView)
        slideBackgroundView.callback = {(index) in
            if let back = self.tapClick{
                back(self.slideBackgroundView.itemsTitle[index])
            }
        }
        slideBackgroundView.snp.makeConstraints {
            $0.left.right.top.equalTo(self.contentView)
            $0.height.equalTo(FBScale(600))
            $0.bottom.equalTo(self.contentView.snp.bottom)
        }

    }

    
    func setData(data:[String:Any],type:Int) {
        modelJson = data
        if(type == 0){
            slideBackgroundView.titleName = "Square table"
            slideBackgroundView.width =  FBScale(368)
            slideBackgroundView.height = FBScale(448)
            slideBackgroundView.cornerRadius = FBScale(60)
        }else{
            slideBackgroundView.titleName = "Circle table"
            slideBackgroundView.width = FBScale(446)
            slideBackgroundView.height = FBScale(446)
            slideBackgroundView.cornerRadius = FBScale(223)
        }
        
        if let arr = data["images"] as? [String]{
            slideBackgroundView.itemsTitle = arr
        }
       
        
    }
}
