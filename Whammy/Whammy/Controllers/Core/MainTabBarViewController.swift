//
//  ViewController.swift
//  Whammy
//
//  Created by Ahmet on 18.06.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: UpComingViewController())
        let vc4 = UINavigationController(rootViewController: CartViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "calendar.badge.clock")
        vc4.tabBarItem.image = UIImage(systemName: "cart")
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Up Coming!"
        vc4.title = "Cart"
        
        tabBar.tintColor = .red
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
    }
}

