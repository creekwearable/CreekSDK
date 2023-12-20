//
//  ScanDeviceViewController.swift
//  CreekSDKDemo
//
//  Created by bean on 2023/7/1.
//

import UIKit
import CreekSDK

class ScanDeviceViewController: CreekBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devides?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ScanCell
        cell?.selectionStyle = .none
        if let a = devides?[indexPath.row] as? ScanDeviceModel{
            cell?.titleLab.text = a.device?.name
            cell?.addressLab.text = a.macAddress ?? a.device?.id
            
            if  (connectDeviceID != nil)  && CreekInterFace.instance.connectStatus == .connect {
                cell?.connectBtn.setTitle(connectDeviceID == a.device?.id ? "disconnect" : "connect", for: .normal)
                cell?.connectBtn.backgroundColor = connectDeviceID == a.device?.id ? .red : .black
            }
            cell?.connect = {
                self.view.showRemark(msg: "connect.....")
                CreekInterFace.instance.connect(id: a.device?.id ?? "") { isBool in
                    self.view.hideRemark()
                    cell?.connectBtn.isSelected = isBool
                    CreekAlert.alertMsg(exception: isBool ? "connect" : "disconnect")
                    if isBool{
                        self.connectDeviceID = a.device?.id
                        CreekInterFace.instance.bindingDevice(bindType: .binNormal, id: nil, code: nil) {
                            print("Success")
                        } failure: {
                            print("Failure")
                        }

                    }
                    tableView.reloadData()
                }
            }
            cell?.disconnect = {
                CreekInterFace.instance.disconnect {
                    self.connectDeviceID = nil
                    tableView.reloadData()
                    
                } failure: { code, message in
                    
                }

            }
        }
        return cell!
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
        tab.backgroundColor = .clear
        tab.separatorStyle = UITableViewCell.SeparatorStyle.none
        tab.separatorColor = UIColor.clear
        tab.register(ScanCell.self, forCellReuseIdentifier: "cell")
        return tab
    }()
    
    var devides:[ScanDeviceModel]?
    var connectDeviceID:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Device"
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(SAFEAREAINSETS.top)
            $0.left.right.bottom.equalTo(self.view)
        }
        scan()
    }
    
    
    func scan(){
        CreekInterFace.instance.getBindDevice { model in
            print("开始扫描")
            CreekInterFace.instance.scan(timeOut: 15) { data in
                let filteredArray = data.filter { element in
                    return !model.contains { e in
                        return e.device?.id == element.device?.id
                    }
                }
                self.devides = filteredArray
                self.tableView.reloadData()
            } endScan: {
                print("结束扫描")
            }
        }
    }
    

}

class ScanCell:UITableViewCell{
    
    //connect Button
    lazy var connectBtn:UIButton = {
        let btn = UIButton.init()
        btn.backgroundColor = .black
        btn.setTitle("connect", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.layer.cornerRadius = FBScale(20)
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(connectDevice), for: .touchUpInside)
        btn.isSelected = false
        return btn
    }()
    
    lazy var titleLab:UILabel = {
        let lab = UILabel.init()
        lab.text = "cw"
        lab.font = UIFont(name: "PingFangSC-Regular", size: FBScale(42))!
        lab.textColor = .white
        return lab
    }()
    
    lazy var addressLab:UILabel = {
        let lab = UILabel.init()
        lab.text = "address"
        lab.font = UIFont(name: "PingFangSC-Regular", size: FBScale(42))!
        lab.textColor = .white
        return lab
    }()
    
    var connect:(() -> ())?
    var disconnect:(() -> ())?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
//        contentView.isUserInteractionEnabled = true
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func layoutUI() {
        contentView.addSubview(connectBtn)
        contentView.addSubview(addressLab)
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(FBScale(20))
            $0.left.equalTo(FBScale(40))
            $0.right.equalTo(connectBtn.snp.left).offset(-FBScale(40))
        }
        addressLab.snp.makeConstraints {
            $0.top.equalTo(titleLab.snp.bottom).offset(FBScale(10))
            $0.left.equalTo(FBScale(40))
            $0.right.equalTo(connectBtn.snp.left).offset(-FBScale(40))
            $0.bottom.equalTo(contentView.snp.bottom).offset(-FBScale(20))
        }
        connectBtn.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(FBScale(20))
            $0.right.equalTo(contentView.snp.right).offset(-FBScale(40))
            $0.width.equalTo(FBScale(300))
            $0.height.equalTo(FBScale(100))
        }
    }
    //MARK:connect to Device
    @objc func connectDevice() {
        if connectBtn.titleLabel?.text == "disconnect"{
            if let disconnect = disconnect {
                disconnect()
            }
        }else{
            if let connect = connect {
                connect()
            }
        }
    }
    
}
