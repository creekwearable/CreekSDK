//
//  CameraPopView.swift
//  ZBUser
//
//  Created by apple on 2021/11/23.
//

import UIKit

public enum CameraType {
    //拍摄
    case CameraTypeShoot
    //相册
    case CameraTypeAlbum
}

class CameraPopView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //背景颜色view的透明度
    private let backgroundViewAlpha : CGFloat = 0.3
    //动画时间
    private let animateDuration : TimeInterval = 0.3
    //内容view的高度
    private var contentHeight : CGFloat =  100
    
    typealias CameraBlock = (_ cameraType:CameraType) -> ()
    var block: CameraBlock?
    
    //初始化方法
    convenience init(frame: CGRect,height : CGFloat){
        self.init(frame:frame)
        self.contentHeight = height
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(backgroundViewAlpha)
        
        //圆角
//        self.contentView.backgroundColor = UIColor.blue
        self.contentView.layer.cornerRadius = 24
        self.contentView.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.layerMinXMinYCorner.rawValue | CACornerMask.layerMaxXMinYCorner.rawValue)
        
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        
        addSubview(contentView)

        contentView.addSubview(shootButton)
        contentView.addSubview(albumButton)
        contentView.addSubview(lineView1)
        
        contentView.addSubview(lineView)
        contentView.addSubview(cancelButton)
        
        shootButton.snp.makeConstraints { make in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(60)
        }
        
        lineView1.snp.makeConstraints { make in
            make.top.equalTo(shootButton.snp.bottom)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(1)
        }
        
        albumButton.snp.makeConstraints { make in
            make.top.equalTo(self.lineView1.snp.bottom)
            make.left.right.equalTo(contentView)
            make.height.equalTo(60)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(albumButton.snp.bottom).offset(0)
            make.left.right.equalTo(contentView)
            make.height.equalTo(8)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalTo(contentView)
            make.height.equalTo(50)
        }
        
    }
    
    //MARK: - ButtonAction
    @objc func shootButtonAction() {
        self.block?(.CameraTypeShoot)
        self.hideSheetView()
    }
    @objc func albumButtonAction() {
        self.block?(.CameraTypeAlbum)
        self.hideSheetView()
    }
    @objc func cancelButtonClick() {
        hideSheetView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        let point = touch.location(in:self)     //获取当前点击位置
        if point.y <= SCREENH - self.contentHeight {
            self.endEditing(true)
            hideSheetView()
        }
    }
    
    //sheetView出现（下）
    func showSheetView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: animateDuration) {
            self.contentView.frame = CGRect.init(x: 0, y: SCREENH - self.contentHeight, width: SCREENW, height: self.contentHeight)
        }
    }
    //sheetView消失
    func hideSheetView() {
        UIView.animate(withDuration: animateDuration, animations: {
            
            self.contentView.frame = CGRect.init(x: 0, y: SCREENH, width: SCREENW, height: self.contentHeight)
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: - LazyLoad
    //主要装载显示内容的view
    public lazy var  contentView : UIView = {
        let  temContentView = UIView()
        temContentView.backgroundColor = UIColor.white
        temContentView.frame = CGRect.init(x: 0, y: SCREENH, width: SCREENW, height: self.contentHeight)
        return temContentView
    }()
    
    lazy var shootButton : UIButton = {
        let button = UIButton.init()
        button.tag = 1200
        button.addTarget(self, action: #selector(shootButtonAction), for: .touchUpInside);
        button.setTitle("camera", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FBScale(32))
        button.setTitleColor(UIColor.colorWithHex(hex: "101A2E", alpha: 1), for: .normal)
//        button.backgroundColor = UIColor.blue
        return button
    }()
    
    lazy var albumButton : UIButton = {
        let button = UIButton.init()
        button.tag = 1300
        button.addTarget(self, action: #selector(albumButtonAction), for: .touchUpInside);
        button.setTitle("photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FBScale(32))
        button.setTitleColor(UIColor.colorWithHex(hex: "101A2E", alpha: 1), for: .normal)
//        button.backgroundColor = UIColor.blue
        return button
    }()
    
    lazy var cancelButton : UIButton = {
        let button = UIButton.init()
        button.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FBScale(32))
        button.setTitleColor(UIColor.colorWithHex(hex: "101A2E", alpha: 1), for: .normal)
//        button.backgroundColor = UIColor.blue
        return button
    }()
    
    lazy var lineView1: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.colorWithHex(hex: "F2F4F5", alpha: 1)
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.colorWithHex(hex: "F7F9FC", alpha: 1)
        return view
    }()

}


