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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
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
                                         image: UIImage(named: "defaultImage.png"),
                                         selectedImage: UIImage(named: "selectedImage.png"))
        
        homeViewController.tabBarItem = homeBarItem
        
        
        let picFeedBarItem = UITabBarItem(title: "Book",
                                          image: UIImage(named: "defaultImage2.png"),
                                          selectedImage: UIImage(named: "selectedImage2.png"))
        picFeedViewController.tabBarItem = picFeedBarItem
        
        
        self.viewControllers = [homeViewController, picFeedViewController]
    }

}
