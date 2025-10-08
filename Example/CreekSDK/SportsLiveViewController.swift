import UIKit
import SnapKit

class SportsLiveViewController: CreekBaseViewController {
    

    private let sportPickerButton = UIButton()
    private let typeLabel = UILabel()
    private let stateLabel = UILabel()
    private let jsonTextView = UITextView()
    
    private let startButton = UIButton()
    private let pauseButton = UIButton()
    private let resumeButton = UIButton()
    private let endButton = UIButton()
    
    private var sports: [sport_type] = []
    private var sportTypes = ["ORUN"]
   private var currentType: sport_type = .orun
    private var isSporting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "sport live"
        setupUI()
        setupLayout()
        setupActions()
        getSportType()
    }
   
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       

      GlobalListenManager.shared.liveSportDataListenCallback = { [weak self] model in
         let json = try? model.jsonString()
         self?.updateJSONText(json ?? "")
       }
       
      GlobalListenManager.shared.liveSportControlListenCallback = { [weak self] model in
         self?.stateLabel.text = "state：\(String(describing: model.controlType).uppercased())"
       }
      
      GlobalListenManager.shared.sportGpsListenCallback =  {model in
         let json = try? model.jsonString()
         print(json ?? "")
         if model.gpsOperate == gps_operate_type.gpsInfoInquire {
            let model = GPSModel()
            model.gpsPermission = 0;
            ///Ask for permission 0 Location permission is not enabled 1 Location permission is enabled
            CreekInterFace.instance.setSportGPS(model: model) {
               
            } failure: { code, message in
               
            }
         }else if model.gpsOperate ==  gps_operate_type.gpsInfoRequest{
            ///You can enable continuous location tracking here.
            ///Then each time, you can take the most recently updated location and send it directly to the firmware.
            let model = GPSModel()
            model.latitude = Int(22.312653 * 1000000)
            model.longitude = Int(114.027986 * 1000000)
            model.accuracy =   Int(8.00 * 100)
            model.gpsPermission = 1
            ///Just set it without worrying about whether it’s successfully sent. The firmware sends location updates every second.
            CreekInterFace.instance.setSportGPS(model: model) {
               
            } failure: { code, message in
               
            }
            
         }else if model.gpsOperate ==  gps_operate_type.gpsInfoEnd{
            ///结束 可以关闭持续定位
         }
         
       }
      
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      GlobalListenManager.shared.liveSportDataListenCallback = nil
      GlobalListenManager.shared.liveSportControlListenCallback = nil
      
   }
    
    func getSportType() {
        CreekInterFace.instance.getSportType { model in
            DispatchQueue.main.async {
                self.sports = model.supportType
                self.sportTypes = model.supportType.map { String(describing: $0).uppercased() }
               self.currentType = self.sports.first ?? .orun
                // 刷新 UI
                if let first = self.sportTypes.first {
                  
                    self.sportPickerButton.setTitle("\(first) ⌄", for: .normal)
                    self.typeLabel.text = "sport type：\(first)"
                }
            }
        } failure: { code, message in
            print("getSportType failure: \(message)")
        }
    }
    
    private func setupUI() {
 
        sportPickerButton.setTitle("ORUN ⌄", for: .normal)
        sportPickerButton.setTitleColor(.black, for: .normal)
        sportPickerButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        sportPickerButton.addTarget(self, action: #selector(selectSportType), for: .touchUpInside)
        view.addSubview(sportPickerButton)
        
 
        typeLabel.text = "sport type：null"
        typeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        typeLabel.textColor = .black
        view.addSubview(typeLabel)
        
        stateLabel.text = "state："
        stateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        stateLabel.textColor = .black
        view.addSubview(stateLabel)
        

        jsonTextView.backgroundColor = UIColor(white: 0.96, alpha: 1)
        jsonTextView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        jsonTextView.textColor = .darkGray
        jsonTextView.isEditable = false
        jsonTextView.layer.cornerRadius = 12
        jsonTextView.text = ""
        view.addSubview(jsonTextView)
        
      
        func styleButton(_ button: UIButton, title: String, color: UIColor) {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.backgroundColor = color
            button.layer.cornerRadius = 24
            view.addSubview(button)
        }
        
        styleButton(startButton, title: "start", color: .systemGreen)
        styleButton(pauseButton, title: "pause", color: .systemOrange)
        styleButton(resumeButton, title: "resume", color: .systemBlue)
        styleButton(endButton, title: "end", color: .systemRed)
    }
    

    private func setupActions() {
        startButton.addTarget(self, action: #selector(startSport), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseSport), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(resumeSport), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(endSport), for: .touchUpInside)
    }
    

    private func setupLayout() {
        sportPickerButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(sportPickerButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        jsonTextView.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(startButton.snp.top).offset(-30)
        }
        
        let buttons = [startButton, pauseButton, resumeButton, endButton]
        let spacing = 16
        
        for (index, button) in buttons.enumerated() {
            button.snp.makeConstraints { make in
                make.height.equalTo(48)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
                if index == 0 {
                    make.left.equalToSuperview().offset(16)
                } else {
                    make.left.equalTo(buttons[index - 1].snp.right).offset(spacing)
                    make.width.equalTo(buttons[index - 1])
                }
                if index == buttons.count - 1 {
                    make.right.equalToSuperview().offset(-16)
                }
            }
        }
    }
    
    // MARK: - 下拉选择动作
   @objc private func selectSportType() {
       let alert = UIAlertController(title: "select type", message: nil, preferredStyle: .actionSheet)
       
       for type in sportTypes {  // 循环变量叫 type
           alert.addAction(UIAlertAction(title: type, style: .default, handler: { [weak self] _ in
               guard let self = self else { return }
               
               // 将字符串转换为 sport_type 枚举
               if let selectedType = self.sports.first(where: { String(describing: $0).uppercased() == type }) {
                   self.currentType = selectedType
               }
               
               self.sportPickerButton.setTitle("\(type) ⌄", for: .normal)
               self.typeLabel.text = "sport type：\(type)"
           }))
       }
       
       alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
       
       if let popover = alert.popoverPresentationController {
           popover.sourceView = sportPickerButton
           popover.sourceRect = sportPickerButton.bounds
       }
       
       present(alert, animated: true)
   }

    

    @objc private func startSport() {
       self.view.showRemark(msg: "loding....")
       CreekInterFace.instance.setSportControl(controlType: .controlStart,self.currentType) {
          self.stateLabel.text = "state：\(String(describing: exercise_control_type.controlStart).uppercased())"
          self.view.hideRemark()
       } failure: { code, message in
          self.view.hideRemark()
       }
    }
    
    @objc private func pauseSport() {
       self.view.showRemark(msg: "loding....")
       CreekInterFace.instance.setSportControl(controlType: .controlPause) {
          self.stateLabel.text = "state：\(String(describing: exercise_control_type.controlPause).uppercased())"
          self.view.hideRemark()
       } failure: { code, message in
          self.view.hideRemark()
       }
    }
    
    @objc private func resumeSport() {
       self.view.showRemark(msg: "loding....")
       CreekInterFace.instance.setSportControl(controlType: .controlResume) {
          self.stateLabel.text = "state：\(String(describing: exercise_control_type.controlStart).uppercased())"
          self.view.hideRemark()
       } failure: { code, message in
          self.view.hideRemark()
       }
    }
    
    @objc private func endSport() {
       self.view.showRemark(msg: "loding....")
       CreekInterFace.instance.setSportControl(controlType: .controlEnd) {
          self.stateLabel.text = "state：\(String(describing: exercise_control_type.controlEnd).uppercased())"
          self.view.hideRemark()
       } failure: { code, message in
          self.view.hideRemark()
       }

    }
    
    func updateJSONText(_ text: String) {
        DispatchQueue.main.async {
            self.jsonTextView.text = text
            let bottom = NSMakeRange(self.jsonTextView.text.count - 1, 1)
            self.jsonTextView.scrollRangeToVisible(bottom)
        }
    }
}
