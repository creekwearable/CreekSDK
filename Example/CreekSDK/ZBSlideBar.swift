

import UIKit
import SnapKit




class ZBSlideColorView: UIView {
    
    open var itemsTitle:[String] = []{
        didSet{
            setupItems()
        }
    }
    
    var titleName:String = "Colors"
    var callback:((_ dex:Int) -> ())?
    var sliderColor:UIColor?
    //      var scrollView :UIScrollView?
    var items:NSMutableArray?
    var imageViews:[UIImageView] = []
    var selectedIndex:Int = 0            //选中的位置
    var flot:CGFloat = 0    //按钮的初始值
    var textalignment:NSTextAlignment = .center
    
    
    
    
    // but名称
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        initScrollView()
    }
    
    lazy var scrollView:UIScrollView = {
        let aview = UIScrollView()
        aview.backgroundColor = UIColor.clear
        aview.showsVerticalScrollIndicator = false
        aview.showsHorizontalScrollIndicator = false
        aview.contentSize.height = 0
        aview.bounces = false
        return aview
    }()
    
    lazy var titleLab:UILabel = {
        let lab = UILabel.init()
        lab.text = "Colors"
        lab.font = UIFont(name: "PingFangSC-Regular", size: FBScale(42))!
        lab.textColor = .white
        return lab
    }()
    
    lazy var connetView:UIView = {
        let aview = UIView()
        return aview
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initScrollView() {
        self.addSubview(titleLab)
        self.addSubview(scrollView)
        scrollView.addSubview(connetView)
        titleLab.snp.makeConstraints {
            $0.top.equalTo(FBScale(20))
            $0.left.equalTo(FBScale(20))
            $0.width.height.greaterThanOrEqualTo(0)
            
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLab.snp.bottom).offset(FBScale(10))
            $0.left.right.bottom.equalTo(self)
        }
        connetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(scrollView)
            $0.width.equalTo(self).priority(.low)
        }
    }
    
    func setupItems() {
        for butview in (scrollView.subviews){
            if butview.isKind(of: UIButton.self)
            {
                butview.removeFromSuperview()
            }
        }
        imageViews.removeAll()
        if itemsTitle.count == 0 {
            return
        }
        
        var upBut:UIImageView = UIImageView.init()
        for index in 0 ..< itemsTitle.count {
            let item = itemsTitle[index]
            let but:UIImageView = UIImageView.init()
            but.isUserInteractionEnabled = true
            but.backgroundColor = UIColor(hexString: item.replacingOccurrences(of: "#", with: ""))
            but.layer.cornerRadius = FBScale(60)
            but.tag = index
            let tap = UITapGestureRecognizer(target: self, action: #selector(ButtonClick(tap: )))
            but.addGestureRecognizer(tap)
            but.layer.masksToBounds = true
            imageViews.append(but)
            connetView.addSubview(but)
            if(index == 0){
                but.snp.makeConstraints {
                    $0.width.height.equalTo(FBScale(120))
                    $0.centerY.equalTo(scrollView)
                    //                    $0.top.equalTo(connetView.snp.top).offset(FBScale(40))
                    $0.left.equalTo(connetView.snp.left).offset(FBScale(20))
                }
            }else if(index == itemsTitle.count - 1){
                but.snp.makeConstraints {
                    $0.width.height.equalTo(FBScale(120))
                    $0.right.equalTo(connetView.snp.right).offset(-FBScale(20))
                    $0.left.equalTo(upBut.snp.right).offset(FBScale(20))
                    $0.centerY.equalTo(scrollView)
                    //                    $0.top.equalTo(connetView.snp.top).offset(FBScale(40))
                }
            }else{
                but.snp.makeConstraints {
                    $0.width.height.equalTo(FBScale(120))
                    $0.left.equalTo(upBut.snp.right).offset(FBScale(20))
                    $0.centerY.equalTo(scrollView)
                    //                    $0.top.equalTo(connetView.snp.top).offset(FBScale(40))
                }
            }
            upBut = but
        }
        
        
        slideBarItemSelected(index: 0)
    }
    //MARK:按钮事件
    @objc func ButtonClick(tap:UITapGestureRecognizer)  {
        
        if let img = tap.view as? UIImageView {
            let tagValue = img.tag
            // 在这里使用 tagValue
            print("Tag value: \(tagValue)")
            slideBarItemSelected(index: tagValue)
            if callback != nil {
                callback!(tagValue)
            }
        }
        
    }
    
    
    func slideBarItemSelected(index:Int) {
        if self.imageViews.count == 0 {
            return
        }
        let bimage = self.imageViews[index]
        
        self.imageViews.forEach { aimage in
            aimage.layer.borderWidth = 1
            aimage.layer.borderColor = UIColor.clear.cgColor
            aimage.layer.masksToBounds = true
        }
        bimage.layer.borderWidth = 3
        bimage.layer.borderColor = UIColor.blue.cgColor
        bimage.layer.masksToBounds = true
        
    }
    
}


class ZBSlideBackgroundView: UIView {
    
    open var itemsTitle:[String] = []{
        didSet{
            setupItems()
        }
    }
    
    var isLocal = false;
    
    var titleName:String = "Background"
    var callback:((_ dex:Int) -> ())?
    var sliderColor:UIColor?
    //      var scrollView :UIScrollView?
    var items:NSMutableArray?
    var imageViews:[UIImageView] = []
    var selectedIndex:Int = 0            //选中的位置
    var flot:CGFloat = 0    //按钮的初始值
    var textalignment:NSTextAlignment = .center
    var isSelectType = true
    
    var height = FBScale(448)
    var width = FBScale(368)
    var cornerRadius = FBScale(60)
    
    // but名称
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        initScrollView()
    }
    
    lazy var scrollView:UIScrollView = {
        let aview = UIScrollView()
        aview.backgroundColor = UIColor.clear
        aview.showsVerticalScrollIndicator = false
        aview.showsHorizontalScrollIndicator = false
        aview.contentSize.height = 0
        aview.bounces = false
        return aview
    }()
    
    lazy var titleLab:UILabel = {
        let lab = UILabel.init()
        lab.text = "Background"
        lab.font = UIFont(name: "PingFangSC-Regular", size: FBScale(42))!
        lab.textColor = .white
        return lab
    }()
    
    lazy var connetView:UIView = {
        let aview = UIView()
        return aview
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initScrollView() {
        self.addSubview(titleLab)
        self.addSubview(scrollView)
        scrollView.addSubview(connetView)
        titleLab.snp.makeConstraints {
            $0.top.equalTo(FBScale(20))
            $0.left.equalTo(FBScale(20))
            $0.width.height.greaterThanOrEqualTo(0)
            
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLab.snp.bottom).offset(FBScale(10))
            $0.left.right.bottom.equalTo(self)
        }
        connetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(scrollView)
            $0.width.equalTo(self).priority(.low)
        }
    }
    
    func setupItems() {
        
        titleLab.text = titleName
        for butview in (scrollView.subviews){
            if butview.isKind(of: UIButton.self)
            {
                butview.removeFromSuperview()
            }
        }
        imageViews.removeAll()
        if itemsTitle.count == 0 {
            return
        }
        
        var upBut:UIImageView = UIImageView.init()
        for index in 0 ..< itemsTitle.count {
            let item = itemsTitle[index]
            let but:UIImageView = UIImageView.init()
            but.backgroundColor = UIColor.blue
            but.contentMode = .scaleAspectFit
            but.isUserInteractionEnabled = true
            
            if(isLocal){
                but.image = UIImage(named: item)
            }else{
                if let data = Data(base64Encoded: item, options: .ignoreUnknownCharacters) {
                    
                    if let image = UIImage(data: data) {
                        but.image = image
                    } else {
                        but.image = UIImage(contentsOfFile: item)
                    }
                } else {
                    but.image = UIImage(contentsOfFile: item)
                }
            }
            
            
            
            but.layer.cornerRadius = cornerRadius
            but.tag = index
            let tap = UITapGestureRecognizer(target: self, action: #selector(ButtonClick(tap: )))
            but.addGestureRecognizer(tap)
            but.layer.masksToBounds = true
            imageViews.append(but)
            connetView.addSubview(but)
            if(index == 0){
                but.snp.makeConstraints {
                    $0.width.equalTo(width)
                    $0.height.equalTo(height)
                    $0.centerY.equalTo(scrollView)
                    $0.left.equalTo(connetView.snp.left).offset(FBScale(20))
                }
            }else if(index == itemsTitle.count - 1){
                but.snp.makeConstraints {
                    $0.width.equalTo(width)
                    $0.height.equalTo(height)
                    $0.right.equalTo(connetView.snp.right).offset(-FBScale(20))
                    $0.left.equalTo(upBut.snp.right).offset(FBScale(20))
                    $0.centerY.equalTo(scrollView)
                }
            }else{
                but.snp.makeConstraints {
                    $0.width.equalTo(width)
                    $0.height.equalTo(height)
                    $0.left.equalTo(upBut.snp.right).offset(FBScale(20))
                    $0.centerY.equalTo(scrollView)
                   
                }
            }
            upBut = but
        }
        
        
        slideBarItemSelected(index: 0)
    }

    
    @objc func ButtonClick(tap:UITapGestureRecognizer)  {
        
        if let img = tap.view as? UIImageView {
            let tagValue = img.tag
            // 在这里使用 tagValue
            print("Tag value: \(tagValue)")
            slideBarItemSelected(index: tagValue)
            if callback != nil {
                callback!(tagValue)
            }
        }
        
        
    }
    

    func slideBarItemSelected(index:Int) {
        if self.imageViews.count == 0 {
            return
        }
        let bimage = self.imageViews[index]
        
        if(isSelectType){
            self.imageViews.forEach { aimage in
                aimage.layer.borderWidth = 1
                aimage.layer.borderColor = UIColor.clear.cgColor
                aimage.layer.masksToBounds = true
            }
            bimage.layer.borderWidth = 3
            bimage.layer.borderColor = UIColor.blue.cgColor
            bimage.layer.masksToBounds = true
            
        }
        
    }
    
    
}


class CustomView: UIView {
    
    lazy var titleLab:UILabel = {
        let lab = UILabel.init()
        lab.text = "Custom function"
        lab.font = UIFont(name: "PingFangSC-Regular", size: FBScale(42))!
        lab.textColor = .black
        return lab
    }()
    
    lazy var aimageView:UIImageView = {
        let aview = UIImageView()
        aview.image = UIImage(named: "arrow_right_icon")
        return aview
    }()
    var callBlock: (()->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tap)
        layoutUI()
    }
    
    func layoutUI(){
        self.addSubview(titleLab)
        self.addSubview(aimageView)
        titleLab.snp.makeConstraints {
            $0.centerY.equalTo(aimageView)
            $0.width.height.greaterThanOrEqualTo(0)
            $0.left.equalTo(FBScale(40))
        }
        aimageView.snp.makeConstraints {
            $0.right.equalTo(-FBScale(40))
            $0.top.equalTo(FBScale(40))
            $0.bottom.equalTo(self.snp.bottom).offset(-FBScale(40))
            $0.width.height.equalTo(FBScale(64))
        }
    }
    
    @objc func tapClick(){
        if let back = callBlock {
            back()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
