//
//  ViewController.swift
//  CreekSDKDemo
//
//  Created by bean on 2023/6/27.
//

import UIKit
import CreekSDK
import ZIPFoundation

class ViewController: CreekBaseViewController,UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource{
   
   let allOptions = [
      "Get device information",
      "Get user information",
      "Set user information",
      "Query time",
      "Set time",
      "Upload (OTA)",
      "Upload (Music)",
      "Upload (Sport Course)",
      "Upload (Route)",
      "Bind device",
      "Unbind",
      "Sync health",
      "Get watch dial",
      "Set watch dial",
      "Delete watch dial",
      "Get table",
      "Get language",
      "Set language",
      "Get alarms",
      "Set alarms",
      "Get disturb",
      "Set disturb",
      "Get contacts",
      "Set contacts",
      "Get SOS contacts",
      "Set SOS contacts",
      "Get shortcut keys",
      "Set shortcut keys",
      "Get card",
      "Set card",
      "Set weather",
      "Get message on/off",
      "Set message on/off",
      "Set message",
      "Get call",
      "Set call",
      "Get health monitor",
      "Set health monitor",
      "Get world clock",
      "Set world clock",
      "Get stand",
      "Set stand",
      "Get water",
      "Set water",
      "Get focus",
      "Set focus",
      "Get app list",
      "Set app list",
      "Get screen",
      "Set screen",
      "Set music",
      "Set database user ID",
      "Get activity data",
      "Get sleep data",
      "Get heart rate data",
      "Get stress data",
      "Get blood oxygen data",
      "Get HRV data",
      "Get sport data",
      "Set status to uploaded",
      "Get good morning",
      "Set good morning",
      "Get calendar",
      "Set calendar",
      "Get health snapshot",
      "Get Watch Sensor",
      "Set Watch Sensor",
      "Get Water Assistant",
   ];
   
   var filteredOptions: [String] = []
   
   // MARK: - UI Components
   lazy var deviceCardView:UIView = {
      let aview = UIView()
      var tag = UITapGestureRecognizer(target: self, action: #selector(toScanPage))
      aview.addGestureRecognizer(tag)
      aview.isUserInteractionEnabled = true
      return aview
   }()
   private let iconView = UIImageView()
   private let deviceTitleLabel = UILabel()
   private let deviceNameLabel = UILabel()
   private let macLabel = UILabel()
   private let statusDotView = UIView()
   private let arrowImageView = UIImageView()
   let searchBar = UISearchBar()
   var deviceModel:ScanDeviceModel?
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
      tab.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      return tab
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemGroupedBackground
      title = "Creek Tool"
      filteredOptions = allOptions
      
      setupDeviceCard()
      setupSearchBar()
      setupTableView()
      initMethod()
      getBindDevice()
      NotificationCenter.default.addObserver(self, selector: #selector(notificationRefresh), name:  NSNotification.Name(rawValue:"deviceRefresh"), object: nil)
      
   }
   
   @objc func notificationRefresh() {
      getBindDevice()
   }
   
   func initMethod() {
      
      CreekInterFace.instance.setupInit {
         CreekInterFace.instance.initSDK()
      
//         CreekInterFace.instance.externalConnect(id: "82028D7C-6289-9D97-EC28-203AA8331DE6") { connectState in
//            print("🌹🌹\(connectState)")
//         }
         CreekInterFace.instance.listenDeviceState { [self] status, deviceName in
            print("\(status) \(deviceName)")
            getBindDevice()
         }
         CreekInterFace.instance.noticeUpdateListen { model in
            
            if(model.eventId == .EVENT_ID_FINE_PHONE){
               
               ///Here you can do some ringing operations. You need to define it yourself.
               
            }
            
            let json = try? JSONEncoder().encode(model)
            if let data = json, let str = String(data: data, encoding: .utf8) {
               print("noticeUpdateListen \(str)")
            }
            
         }
         CreekInterFace.instance.phoneBookInit();
         CreekInterFace.instance.bluetoothStateListen { state in
            switch(state){
            case .unknown:
               print("State unknown")
               break
            case .unauthorized:
               print(" The application is not authorized to use the Bluetooth Low Energy role")
               break
            case .on:
//               CreekInterFace.instance.externalConnect(id: "63E4B85A-4C68-D954-5856-CE37C78F7236") { connectState in
//                  CreekInterFace.instance.getFirmware { model in
//                     print("🥁🥁🥁🥁🥁🥁🥁🥁🥁🥁🥁")
//                  } failure: { code, message in
//                     
//                  }
//
//                  print("🌹🌹\(connectState)")
//               }
               print("Bluetooth is currently powered on and available to use")
               break
            case .off:
               print("Bluetooth is currently powered off")
               break
            }
         }
         let keyId = "*********"
         let publicKey = "************"
         
         CreekInterFace.instance.aiVoiceConfig(keyId: keyId, publicKey: publicKey)
         CreekInterFace.instance.setAiVoiceCountry(countryCode: "US")
         CreekInterFace.instance.setAiVoiceCity(cityName: "New York")
         
         CreekInterFace.instance.calendarConfig(timerMinute: 10, systemCalendarName: "CREEK", isSupport: true) { str in
            print(str)
         }
         
         
         CreekSDK.instance.liveSportDataListen { model in
            let json = try? model.jsonString()
            print(json)
         }
         CreekSDK.instance.liveSportControlListen { model in
            let json = try? model.jsonString()
             print(json)
         }
         
//         CreekSDK.instance.setSportControl(controlType: .controlResume) {
//            print("success")
//         } failure: { code, message in
//            print("fail")
//         }
         
         CreekInterFace.instance.ephemerisInit(keyId: keyId, publicKey: publicKey) {
            ///Ask for GPS data, and get the latest GPS data every time you ask.
            let model = EphemerisGPSModel()
            model.altitude = 10
            model.latitude = Int(22.312653 * 1000000)
            model.longitude = Int(114.027986 * 1000000)
            model.isVaild = true
            return model
            
         }
         CreekInterFace.instance.watchResetListen {
            print("listen watchResetListen")
            CreekInterFace.instance.bindingDevice(bindType: .binNormal, id: nil, code: nil) {
               
            } failure: {
               
            }
            
         }
         CreekInterFace.instance.exceptionListen { model in
            print("😄😄\(model)")
         }
        
      }
  
   }
   
   // MARK: - 顶部设备信息卡片
   func setupDeviceCard() {
      deviceCardView.isHidden = false
      view.addSubview(deviceCardView)
      
      deviceCardView.backgroundColor = UIColor(hexString: "CC1B1B2E")
      deviceCardView.layer.cornerRadius = FBScale(20)
      deviceCardView.layer.shadowColor = UIColor.black.cgColor
      deviceCardView.layer.shadowOpacity = 0.1
      deviceCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
      deviceCardView.layer.shadowRadius = 4
      
      // 图标
      iconView.image = UIImage(named: "icon_device")
      iconView.contentMode = .scaleAspectFit
      deviceCardView.addSubview(iconView)
      
      // 设备名标题
      deviceNameLabel.text = ""
      deviceNameLabel.textColor = .white
      deviceNameLabel.font = .boldSystemFont(ofSize: FBScale(34))
      deviceCardView.addSubview(deviceNameLabel)
      
      // MAC 地址
      macLabel.text = ""
      macLabel.font = .systemFont(ofSize: FBScale(28))
      macLabel.textColor = .white
      deviceCardView.addSubview(macLabel)
      
      // 连接状态 - 圆点
      statusDotView.backgroundColor = .systemGray
      statusDotView.layer.cornerRadius = FBScale(6)
      statusDotView.clipsToBounds = true
      deviceCardView.addSubview(statusDotView)
      
      // 右箭头
      arrowImageView.image = UIImage(named: "arrow_right_icon") // SF Symbol
      deviceCardView.addSubview(arrowImageView)
      
      // 布局
      deviceCardView.snp.makeConstraints { make in
         make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(FBScale(10))
         make.left.right.equalToSuperview().inset(FBScale(16))
         make.height.equalTo(FBScale(140))
      }
      
      iconView.snp.makeConstraints { make in
         make.left.equalToSuperview().offset(FBScale(16))
         make.centerY.equalToSuperview()
         make.width.height.equalTo(FBScale(50))
      }
      
      deviceNameLabel.snp.makeConstraints { make in
         make.left.equalTo(iconView.snp.right).offset(FBScale(12))
         make.top.equalToSuperview().offset(FBScale(28))
      }
      
      macLabel.snp.makeConstraints { make in
         make.left.equalTo(deviceNameLabel)
         make.top.equalTo(deviceNameLabel.snp.bottom).offset(FBScale(8))
      }
      
      statusDotView.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.right.equalTo(arrowImageView.snp.left).offset(-FBScale(40))
         make.width.height.equalTo(FBScale(12))
      }
      
      arrowImageView.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.right.equalToSuperview().offset(-FBScale(20))
         make.width.height.equalTo(FBScale(60))
      }
   }
   
   func setUIData(model:ScanDeviceModel){
      statusDotView.backgroundColor = CreekInterFace.instance.connectStatus == .connect ? .systemBlue : .systemGray
      print(model.device?.name ?? "")
      deviceNameLabel.text = model.device?.name ?? ""
      macLabel.text = model.macAddress ?? model.device?.id ?? ""
      
   }
   
   // MARK: - 搜索栏
   func setupSearchBar() {
      view.addSubview(searchBar)
      searchBar.delegate = self
      searchBar.placeholder = "search"
      
      searchBar.snp.makeConstraints { make in
         make.top.equalTo(deviceCardView.snp.bottom).offset(FBScale(10))
         make.left.right.equalToSuperview()
         make.height.equalTo(FBScale(100))
      }
   }
   
   // MARK: - 列表
   func setupTableView() {
      view.addSubview(tableView)
      tableView.delegate = self
      tableView.dataSource = self
      tableView.separatorStyle = .none
      tableView.backgroundColor = .clear
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
      
      tableView.snp.makeConstraints { make in
         make.top.equalTo(searchBar.snp.bottom).offset(FBScale(10))
         make.left.right.bottom.equalToSuperview()
      }
      tableView.reloadData()
   }
   
   // MARK: - UITableViewDataSource
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return filteredOptions.count
   }
   
   // MARK: - UITableViewDelegate
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return FBScale(180)
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let title = filteredOptions[indexPath.row]
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      
      cell.selectionStyle = .none
      cell.textLabel?.text = title
      cell.textLabel?.font = .systemFont(ofSize: FBScale(36))
      cell.textLabel?.textColor = (title.contains("OTA") || title.contains("Music") || title.contains("Route") || title.contains("Sport Course")) ? .systemRed : .black
      cell.contentView.backgroundColor = .white
      cell.contentView.layer.cornerRadius = FBScale(20)
      cell.contentView.layer.masksToBounds = true
      
      // Add a border around the cell
      cell.contentView.layer.borderColor = UIColor.systemGray.cgColor
      cell.contentView.layer.borderWidth = 1.0
      
      // Add shadow to make the cell pop
      cell.contentView.layer.shadowColor = UIColor.black.cgColor
      cell.contentView.layer.shadowOpacity = 0.5
      cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
      cell.contentView.layer.shadowRadius = 10
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      switch allOptions[indexPath.row] {
      case "Upload (Music)":
         
       
         let vc = MusicUploadViewController()
         self.navigationController?.pushViewController(vc, animated: true)
         break
      case "Upload (Sport Course)":
         let vc = SportCourseUploadViewController()
         self.navigationController?.pushViewController(vc, animated: true)
         break
      case "Upload (Route)":
         let vc = RouteUploadViewController()
         self.navigationController?.pushViewController(vc, animated: true)
         break
      case "Upload (OTA)":
         let vc = OTAUploadViewController()
         self.navigationController?.pushViewController(vc, animated: true)
         break
      default:
         let vc = CommandReplyViewController()
         vc.title = allOptions[indexPath.row]
         vc.titleStr = allOptions[indexPath.row]
         self.navigationController?.pushViewController(vc, animated: true)
      }
   }
   
   // MARK: - 搜索功能
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      filteredOptions = searchText.isEmpty
      ? allOptions
      : allOptions.filter { $0.localizedCaseInsensitiveContains(searchText) }
      tableView.reloadData()
   }
   
   
   
   @objc func toScanPage() {
      let vc = BluetoothDeviceListViewController()
      self.navigationController?.pushViewController(vc, animated: true)
   }
   
   func getBindDevice(){
      CreekInterFace.instance.getBindDevice { [self] model in
         model.forEach { devide in
            if devide.lastBind ?? false{
               self.deviceModel = devide
               setUIData(model: devide)
            }
         }
      }
   }

}

