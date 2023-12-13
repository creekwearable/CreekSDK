//
//  ViewController.swift
//  CreekSDKDemo
//
//  Created by bean on 2023/6/27.
//

import UIKit
import CreekSDK

class ViewController: CreekBaseViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCmd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HomeCell
        cell?.selectionStyle = .none
        cell?.titleLab.text = listCmd[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CommandReplyViewController()
        vc.title = listCmd[indexPath.row]
        vc.titleStr = listCmd[indexPath.row]
        switch listCmd[indexPath.row]{
        case "Sync":
            CreekInterFace.instance.sync { progress in
                print("sync \(progress)")
            } syncSuccess: {
                print("syncSuccess")
            } syncFailure: {
                print("syncFailure")
            }
            break
        case "Upload":
            if let path =  Bundle.main.path(forResource: "res", ofType: "ota"){
                do {
                    let fileData:Data = try Data(contentsOf: URL(fileURLWithPath: path))
                    CreekInterFace.instance.upload(fileName: "res.ota", fileData: fileData) { progress in
                        print(progress)
                    } uploadSuccess: {
                        print("uploadSuccess")
                    } uploadFailure: { code, message in
                        print(message)
                    }

                } catch {
                    print("\(error)")
                }


            }else{
                print("file does not exist")
            }
            break
        case "Binding":
            CreekInterFace.instance.bindingDevice(bindType: .binNormal, id: nil, code: nil) {
                print("Success")
            } failure: {
                print("Failure")
            }
            //            if(textField.text == "123"){
            //                CreekInterFace.instance.bindingDevice(bindType: .bindRemove, id: nil, code: nil) {
            //                    ///
            //                } failure: {
            //
            //                }
            //            }else{
            //                CreekInterFace.instance.bindingDevice(bindType: .bindPairingCode, id: nil, code: textField.text) {
            //                    print("Success")
            //                } failure: {
            //                    print("Failure")
            //                }
            //            }
                        
                        


                        break
            
        case "getLogPath":
            // 创建分享视图控制器
            self.view.showRemark(msg: "")
            CreekInterFace.instance.getLogPath { path in
                self.view.hideRemark()
                let activityViewController = UIActivityViewController(activityItems: [NSURL(fileURLWithPath: path)], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
            break
        case "getFirmwareLogPath":
            // 创建分享视图控制器
            self.view.showRemark(msg: "")
            CreekInterFace.instance.getFirmwareLogPath { path in
                self.view.hideRemark()
                let activityViewController = UIActivityViewController(activityItems: [NSURL(fileURLWithPath: path)], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
            
            break
           
            
            
      
        

        default:
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    lazy var textField:UITextField = {
        let tab = UITextField(frame: CGRect.zero)
        tab.backgroundColor = .red
        tab.text = "123"
        return tab
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
        tab.backgroundColor = .darkGray
        tab.separatorStyle = UITableViewCell.SeparatorStyle.none
        tab.separatorColor = UIColor.clear
        tab.register(HomeCell.self, forCellReuseIdentifier: "cell")
        return tab
    }()
    
    var listCmd:[String] = ["Binding", "Get Device Information", "Sync", "Upload", "Get Device Bluetooth Status","connect Bluetooth Status", "Get Language", "Set Language", "Sync Time", "Get Time", "Get User Information", "Set User Information", "Get Alarm Clock", "Set Alarm Clock", "Get Do Not Disturb", "Set Do Not Disturb", "Get Screen Brightness", "Set Screen Brightness", "Get Health Monitoring", " Health monitoring setting", "Sleep monitoring acquisition", "Sleep monitoring setting", "World clock acquisition", "World clock setting", "Message switch query", "Message switch setting", "Set weather", "Incoming call configuration query ","Incoming call configuration settings", "Contacts query", "Contacts settings", "Exercise self-identification query", "Exercise self-identification settings", "Exercise sub-item data query", "Exercise sub-item data setting ","Inquiry about the arrangement order of device exercise","Setting the arrangement order of device exercise","Get the type of exercise supported by the device","Setting the heart rate interval","Delete the dial","Query the dial","Set the dial","System operation ","Query activity data", "Query sleep data", "Query heart rate data", "Query pressure data", "Query noise data", "Query blood oxygen data", "Exercise record list", "Query exercise details" ,"Range query exercise record","Delete exercise record","Get bound device","setDBUserID","rawQueryDB","Off-line ephemeris","ephemeris","phone book","getLogPath","getFirmwareLogPath"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "operating platform"
        setRight()
        view.addSubview(textField)
        view.addSubview(tableView)
        textField.snp.makeConstraints{
            $0.top.equalTo(SAFEAREAINSETS.top + 44)
            $0.height.equalTo(40)
            $0.left.right.equalTo(self.view)
        }
        tableView.snp.makeConstraints {
//            $0.top.equalTo(SAFEAREAINSETS.top)
            $0.top.equalTo(textField.snp.bottom)
            $0.left.right.bottom.equalTo(self.view)
        }
        
        CreekInterFace.instance.listenDeviceState { status, deviceName in

            print("\(status) \(deviceName)")
        }
        CreekInterFace.instance.noticeUpdateListen { model in
            let json = try? JSONEncoder().encode(model)
            if let data = json, let str = String(data: data, encoding: .utf8) {
                print("noticeUpdateListen \(str)")
            }
           
        }
        
    }
    
    func setRight(){
        let but = UIButton(type: .custom)
        but.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        but.setTitleColor(.black, for: .normal)
        but.setTitle("Bluetooth", for: .normal)
        but.addTarget(self, action: #selector(blueClick), for: .touchUpInside)
        let itemmeunbut = UIBarButtonItem.init(customView: but)
        self.navigationItem.rightBarButtonItem = itemmeunbut
    }
    
    

    @objc func blueClick()  {
        let vc = ScanDeviceViewController()
        UIViewController.currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }


}

class HomeCell:UITableViewCell{
    
    lazy var titleLab:UILabel = {
        let lab = UILabel.init()
        lab.text = "sssss"
        lab.font = UIFont(name: "PingFangSC-Regular", size: FBScale(42))!
        lab.textColor = .white
        return lab
    }()
    lazy var lineLab:UILabel = {
        let lab = UILabel.init()
        lab.backgroundColor = .white
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI(){
        contentView.addSubview(titleLab)
        contentView.addSubview(lineLab)
        titleLab.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.height.width.greaterThanOrEqualTo(0)
            $0.center.equalTo(contentView)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
        lineLab.snp.makeConstraints {
            $0.right.equalTo(contentView.snp.right).offset(-FBScale(20))
            $0.left.equalTo(contentView.snp.left).offset(FBScale(20))
            $0.height.equalTo(1)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-1)
        }
        
    }
}

