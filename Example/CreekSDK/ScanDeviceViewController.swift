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



class BluetoothDeviceListViewController: CreekBaseViewController {
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private let refreshButton = UIButton()
    private let searchBar = UISearchBar()
   lazy var tableView:UITableView = {
       let tab = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
       tab.delegate = self
       tab.dataSource = self
       tab.estimatedRowHeight = 60
       tab.estimatedSectionHeaderHeight = 0
       tab.estimatedSectionFooterHeight = 0
       tab.showsVerticalScrollIndicator = false
       tab.showsHorizontalScrollIndicator = false
       tab.backgroundColor = .clear
       tab.separatorStyle = UITableViewCell.SeparatorStyle.none
       tab.separatorColor = UIColor.clear
       tab.register(BluetoothDeviceCell.self, forCellReuseIdentifier: "BluetoothDeviceCell")
       return tab
   }()
    var devides:[ScanDeviceModel] = []
   var filteredDevices: [ScanDeviceModel] = []
   var connectDeviceID:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bluetooth device"
        
        setupViews()
        layoutViews()
        scan()
       
    }
   func scan(){
      CreekInterFace.instance.scan(timeOut: 15) { data in

         let filteredArray = data.sorted {
             ($0.rssi ?? -100) > ($1.rssi ?? -100)
          }
          self.devides = filteredArray
          self.filteredDevices = filteredArray
          self.tableView.reloadData()
      } endScan: {
          print("结束扫描")
      }
   }

    private func setupViews() {
   
        
        // Refresh Button
        refreshButton.setTitle("refresh", for: .normal)
        refreshButton.setTitleColor(.systemBlue, for: .normal)
        refreshButton.titleLabel?.font = .systemFont(ofSize: 16)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshButton)
        

        // Search Bar
        searchBar.placeholder = "search"
        searchBar.delegate = self
        searchBar.keyboardType = .asciiCapable
        searchBar.searchBarStyle = .minimal
        

        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(refreshButton)
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }

    private func layoutViews() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(30)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().offset(-12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension BluetoothDeviceListViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredDevices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothDeviceCell") as? BluetoothDeviceCell
       let deviceInfo = filteredDevices[indexPath.row]
       cell?.contentView.backgroundColor = .white
       let isConnected = self.connectDeviceID == deviceInfo.device?.id ?? ""
       cell?.configure(name: deviceInfo.device?.name ?? "", mac: (deviceInfo.macAddress ?? deviceInfo.device?.id) ?? "", rssi: deviceInfo.rssi ?? 100, isConnected: isConnected)
        return cell!
    }
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      self.view.showRemark(msg: "connect.....")
      let deviceInfo = filteredDevices[indexPath.row]
      CreekInterFace.instance.connect(id: deviceInfo.device?.id ?? "") { isBool in
          self.view.hideRemark()
          CreekAlert.alertMsg(exception: isBool ? "connect" : "disconnect")
          if isBool{
              self.connectDeviceID = deviceInfo.device?.id ?? ""
              CreekInterFace.instance.bindingDevice(bindType: .binNormal, id: nil, code: nil) {
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue:"deviceRefresh"), object: self, userInfo: nil)
                  print("Success")
              } failure: {
                  print("Failure")
              }
          }
          tableView.reloadData()
      }
   }
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80
   }
   
}

extension BluetoothDeviceListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredDevices = devides
            tableView.reloadData()
            return
        }
        
        let keyword = searchText.lowercased()
        filteredDevices = devides.filter { device in
            let name = device.device?.name?.lowercased() ?? ""
            let mac = device.macAddress?.lowercased() ?? device.device?.id?.lowercased() ?? ""
            return name.contains(keyword) || mac.contains(keyword)
        }
        tableView.reloadData()
    }
}



class BluetoothDeviceCell: UITableViewCell {
    
    private let nameLabel = UILabel()

    private let rssiLabel = UILabel()
    private let connectButton = UIButton()
   private let infoContainer = UIView()
   
   lazy var macLabel: UILabel = {
      let lab = UILabel()
      lab.text = "sport"
      lab.textColor = .gray
      lab.font = UIFont.init(name: "PingFangSC-Regular", size: FBScale(40))
      return lab
  }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        rssiLabel.font = .systemFont(ofSize: 14)
        rssiLabel.textColor = .gray
        connectButton.layer.cornerRadius = 18
        connectButton.titleLabel?.font = .systemFont(ofSize: 15)
        connectButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        connectButton.setTitleColor(.white, for: .normal)
        connectButton.isEnabled = false
       
       
       contentView.addSubview(infoContainer)
       infoContainer.addSubview(nameLabel)
       infoContainer.addSubview(macLabel)

        contentView.addSubview(rssiLabel)
        contentView.addSubview(connectButton)
    }

    private func layoutViews() {
       
       infoContainer.snp.makeConstraints { make in
           make.left.equalToSuperview().offset(20)
           make.centerY.equalToSuperview()
           make.right.lessThanOrEqualToSuperview().offset(-100) // 防止内容超出（可调）
       }

       nameLabel.snp.makeConstraints { make in
           make.top.left.right.equalToSuperview()
       }

       macLabel.snp.makeConstraints { make in
           make.top.equalTo(nameLabel.snp.bottom).offset(10)
           make.left.right.bottom.equalToSuperview()
           make.width.lessThanOrEqualTo(SCREENW - FBScale(400)) // 可选限制宽度
       }

        rssiLabel.snp.makeConstraints { make in
            make.centerY.equalTo(connectButton)
            make.right.equalTo(connectButton.snp.left).offset(-8)
        }

        connectButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
            make.width.greaterThanOrEqualTo(0)
            make.height.equalTo(36)
        }
    }

    func configure(name: String, mac: String, rssi: Int, isConnected: Bool) {
        nameLabel.text = name
        macLabel.text = mac
        rssiLabel.text = "\(rssi)"
        let title = isConnected ? "disconnect" : "connect"
        connectButton.setTitle(title, for: .normal)
        connectButton.backgroundColor = isConnected ? .systemRed : .systemBlue
    }
}

