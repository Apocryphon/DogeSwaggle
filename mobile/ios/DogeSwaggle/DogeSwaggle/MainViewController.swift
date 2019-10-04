//
//  MainViewController.swift
//  DogeSwaggle
//
//  Created by Richard Yeh on 10/3/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    var homeViewController: DogeHomeViewController
    var picFeedViewController: PicFeedViewController
    
    let selectedPinkColor = UIColor(red:0.93, green:0.18, blue:0.55, alpha:1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        UITabBar.appearance().tintColor = selectedPinkColor
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        homeViewController = DogeHomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        picFeedViewController = PicFeedViewController()

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        homeViewController = DogeHomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        picFeedViewController = PicFeedViewController()

        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let homeBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(named: "home.png"),
                                         selectedImage: nil)
        homeViewController.tabBarItem = homeBarItem
        
        let picFeedBarItem = UITabBarItem(title: "Book",
                                          image: UIImage(named: "calendar.png"),
                                          selectedImage: nil)
        picFeedViewController.tabBarItem = picFeedBarItem

        self.viewControllers = [homeViewController, picFeedViewController]
    }
    
}
