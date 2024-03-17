//
//  BaseSheetView.swift
//  fastbuy
//  有黑色背景从下而上动画出现的view
//  Created by Daniel on 2017/10/14.
//  Copyright © 2017年 sanweidu. All rights reserved.
//

import UIKit
//背景颜色view的透明度
private let backgroundViewAlpha : CGFloat = 0.3
//动画时间
private let animateDuration : TimeInterval = 0.3


class BaseSheetView: UIView {
    
    
    var ishiddenview:(()->())?
    
    
    //主要装载显示内容的view
    public lazy var  contentView : UIView = {
        let  temContentView = UIView()
        temContentView.backgroundColor = UIColor.white
        temContentView.frame = CGRect.init(x: 0, y: SCREENH, width: SCREENW, height: self.contentHeight)
        return temContentView
    }()
    //内容view的高度
    private var contentHeight : CGFloat =  100
    
    //初始化方法
    convenience init(frame: CGRect,height : CGFloat){
        self.init(frame:frame)
        self.contentHeight = height
        self.setUpUI()
    }
    //无法调用的初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:设置UI   出现消失动画  以及点击事件处理
extension BaseSheetView{
    //设置UI
    private func  setUpUI()  {
        
        addSubview(contentView)
        //单独设置父视图alpha不设置子视图
        self.backgroundColor = UIColor.black.withAlphaComponent(backgroundViewAlpha)
    }
    

    
    //sheetView出现（下）
    func showSheetView(){
        if let mainWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            // 在此处使用 mainWindow
            // 例如：
            let rootViewController = mainWindow.rootViewController
            rootViewController?.view.addSubview(self)
           
        }
        UIView.animate(withDuration: animateDuration) {
            self.contentView.frame = CGRect.init(x: 0, y: SCREENH - self.contentHeight, width: SCREENW, height: self.contentHeight)
        }
    }
    //sheetView消失
   @objc func hideSheetView()  {
        UIView.animate(withDuration: animateDuration, animations: {
            
            self.contentView.frame = CGRect.init(x: 0, y: SCREENH, width: SCREENW, height: self.contentHeight)
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        let point = touch.location(in:self)     //获取当前点击位置
        if point.y <= SCREENH - self.contentHeight{
            hideSheetView()
        }
        
   
        
    }
    
}
