//
//  SXTabBarController.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/8.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class SXTabBarController: UITabBarController , UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabbarsub : UITabBar = UITabBar.appearance()
        //tabbarsub.backgroundImage = RFFGetImageWithColor(color: UIColor.white)
        tabbarsub.shadowImage = UIImage.init()
        
        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: -2.0, height: -2.0)
        self.tabBar.layer.shadowOpacity = 0.2
        self.tabBar.layer.shadowRadius = 2.0
        delegate = self
    }
    
    func addRootChild(childController:UIViewController , title:String , normalImageName:String ,selectedImageName:String) {
        childController.title = title
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.green], for: UIControl.State.selected)
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.normal)
        childController.tabBarItem.selectedImage = UIImage.init(named: selectedImageName)
        childController.tabBarItem.image = UIImage.init(named: normalImageName)
        let nav: SXNavgationController = SXNavgationController.init(rootViewController: childController)
        self.addChild(nav)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
