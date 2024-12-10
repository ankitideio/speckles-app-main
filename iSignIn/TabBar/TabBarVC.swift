//
//  TabBarVC.swift
//  EventManagement
//
//  Created by meet sharma on 12/07/23.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCustomTabBarView()
    }
    //MARK: - FUNCTION
    
    private func addCustomTabBarView() {
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        tabBar.layer.shadowOffset = CGSize(width: -4, height: -6)
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowRadius = 10
    
        
    }
    
    
    
    
}
