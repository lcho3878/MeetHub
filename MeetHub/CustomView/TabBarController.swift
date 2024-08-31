//
//  TabBarController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = HomeViewController()
        homeVC.viewType = .home
        let homeNaVC = UINavigationController(rootViewController: homeVC)
        homeNaVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let profileVC = ProfileViewController()
        let profileNaVC = UINavigationController(rootViewController: profileVC)
        profileNaVC.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person.circle.fill"), tag: 1)
    
        tabBar.tintColor = AppColor.mint
        setViewControllers([homeNaVC, profileNaVC], animated: true)
    }
    
}
