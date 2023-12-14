//
//  PonyBaseViewController.swift
//  PonySpeedup
//
//  Created by page on 2020/2/26.
//  Copyright © 2020 page. All rights reserved.
//

import UIKit



class CreekBaseViewController: UIViewController,UIGestureRecognizerDelegate {

    lazy var navigationHeight: CGFloat = {
        return (self.navigationController?.navigationBar.frame.size.height)!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
   

        setLeftBack()
    }

    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

    }
    override func viewWillDisappear(_ animated: Bool) {
        // 如果有loading存在就取消
        self.view.hideRemark()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    func setLeftBack() {
        let back = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = back
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_nav_back")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_nav_back")
//        self.navigationController?.navigationBar.tintColor = .white
    }

    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
}

//获取当前ViewController
extension UIViewController {
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}
