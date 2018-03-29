//
//  TabBarController.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/18/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange//.lightGray
        
        ///SearchVC
        let searchNavigation = UINavigationController(rootViewController: SearchViewController())
        ///FavoriteVC
        let favoriteNavigation = UINavigationController(rootViewController: FavoriteCollectionViewController())
        
        searchNavigation.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "search icon"), tag: 0)
        favoriteNavigation.tabBarItem = UITabBarItem(title: "Favorites", image: #imageLiteral(resourceName: "collection icon"), tag: 1)
        let tabList = [searchNavigation, favoriteNavigation]
        viewControllers = tabList
    }


}
