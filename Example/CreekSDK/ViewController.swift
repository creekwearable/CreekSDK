//
//  ViewController.swift
//  CreekSDKDemo
//
//  Created by bean on 2023/6/27.
//

import UIKit
import CreekSDK
import ZIPFoundation

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
    
    lazy var deviceView:DeviceView = {
        let aview = DeviceView(frame: CGRect.zero)
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
        tab.backgroundColor = .darkGray
        tab.separatorStyle = UITableViewCell.SeparatorStyle.none
        tab.separatorColor = UIColor.clear
        tab.register(HomeCell.self, forCellReuseIdentifier: "cell")
        return tab
    }()
    
    var listCmd:[String] = ["Binding", "Get Device Information", "Sync", "Upload", "Get Device Bluetooth Status","connect Bluetooth Status", "Get Language", "Set Language", "Sync Time", "Get Time", "Get User Information", "Set User Information", "Get Alarm Clock", "Set Alarm Clock", "Get Do Not Disturb", "Set Do Not Disturb", "Get Screen Brightness", "Set Screen Brightness", "Get Health Monitoring", " Health monitoring setting", "Sleep monitoring acquisition", "Sleep monitoring setting", "World clock acquisition", "World clock setting", "Message switch query", "Message switch setting", "Set weather", "Incoming call configuration query ","Incoming call configuration settings", "Contacts query", "Contacts settings", "Exercise self-identification query", "Exercise self-identification settings", "Exercise sub-item data query", "Exercise sub-item data setting ","Inquiry about the arrangement order of device exercise","Setting the arrangement order of device exercise","Get the type of exercise supported by the device","Setting the heart rate interval","Delete the dial","Query the dial","Set the dial","System operation ","Query activity data", "Query sleep data", "Query heart rate data", "Query pressure data", "Query noise data", "Query blood oxygen data", "Exercise record list", "Query exercise details" ,"Range query exercise record","Delete exercise record","Get bound device","setDBUserID","rawQueryDB","Off-line ephemeris","ephemeris","phone book","getLogPath","getFirmwareLogPath"]
    
    var deviceModel:ScanDeviceModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "operating platform"
        setRight()
        view.addSubview(deviceView)
        view.addSubview(textField)
        view.addSubview(tableView)
        deviceView.snp.makeConstraints{
            $0.top.equalTo(SAFEAREAINSETS.top + 44)
            $0.height.equalTo(FBScale(200))
            $0.left.right.equalTo(self.view)
        }
        textField.snp.makeConstraints{
            $0.top.equalTo(deviceView.snp.bottom).offset(20)
            $0.height.equalTo(40)
            $0.left.right.equalTo(self.view)
        }
        tableView.snp.makeConstraints {
//            $0.top.equalTo(SAFEAREAINSETS.top)
            $0.top.equalTo(textField.snp.bottom)
            $0.left.right.equalTo(self.view)
            $0.bottom.equalTo(self.view).offset(-SAFEAREAINSETS.bottom)
        }
        
        CreekInterFace.instance.listenDeviceState { status, deviceName in
            if status == .connect{
                self.getBindDevice()
            }else{
                self.deviceView.setUI(device: self.deviceModel, state: CreekInterFace.instance.connectStatus)

            }
            print("\(status) \(deviceName)")
        }
        CreekInterFace.instance.noticeUpdateListen { model in
            let json = try? JSONEncoder().encode(model)
            if let data = json, let str = String(data: data, encoding: .utf8) {
                print("noticeUpdateListen \(str)")
            }
           
        }
        deviceView.connect = {
            CreekInterFace.instance.inTransitionDevice(id: self.deviceModel!.device?.id ?? "") { isBool in
                
            }
        }
        deviceView.disconnect = {
           
            CreekInterFace.instance.autoConnect(type: 0)
            CreekInterFace.instance.disconnect {
                
            } failure: { code, message in
                
            }

        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBindDevice()
    }
    
    func getBindDevice(){
        CreekInterFace.instance.getBindDevice { model in
            model.forEach { devide in
                if devide.lastBind ?? false{
                    self.deviceModel = devide
                    self.deviceView.setUI(device: self.deviceModel!, state: CreekInterFace.instance.connectStatus)
                }
            }
        }
    }
    
    func isDirectoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
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

class DeviceView:UIView{
    
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
    
    lazy var titleLab2:UILabel = {
        let lab = UILabel.init()
        lab.text = "no bind device"
        lab.font = UIFont(name: "PingFangSC-Regular", size: FBScale(42))!
        lab.textColor = .white
        return lab
    }()
    

    
    var connect:(() -> ())?
    var disconnect:(() -> ())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func layoutUI() {
        self.addSubview(connectBtn)
        self.addSubview(titleLab)
        self.addSubview(titleLab2)
        titleLab2.isHidden = true;
        titleLab.snp.makeConstraints {
            $0.top.equalTo(self).offset(FBScale(20))
            $0.left.equalTo(FBScale(40))
            $0.right.equalTo(connectBtn.snp.left).offset(-FBScale(40))
        }
        connectBtn.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(FBScale(20))
            $0.right.equalTo(self.snp.right).offset(-FBScale(40))
            $0.width.equalTo(FBScale(300))
            $0.height.equalTo(FBScale(100))
        }
        
        titleLab2.snp.makeConstraints {
            $0.center.equalTo(self.snp.center)
            $0.height.equalTo(FBScale(100))
            $0.width.equalTo(FBScale(400))
            
        }
    }
    func setUI(device:ScanDeviceModel?,state:connectionStatus){
        if let d = device{
            titleLab2.isHidden = true
            titleLab.isHidden = false
            connectBtn.isHidden = false
            titleLab.text = d.device?.name
            if(state == .connect){
                connectBtn.setTitle("disconnect", for: .normal)
            }else if(state == .unconnected){
                connectBtn.setTitle("connect", for: .normal)
            }
        }else{
            titleLab2.isHidden = false
            titleLab.isHidden = true
            connectBtn.isHidden = true
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

