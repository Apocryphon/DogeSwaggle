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
    var statsViewController: StatsViewController
    var hasShownIntro = false
    
    let selectedPinkColor = UIColor(red:0.93, green:0.18, blue:0.55, alpha:1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        UITabBar.appearance().tintColor = selectedPinkColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        if !hasShownIntro {
            let viewController = IntroViewController(nibName: "IntroViewController", bundle: nil)
            if #available(iOS 13.0, *) {
                viewController.modalPresentationStyle = .fullScreen
            }
            self.present(viewController, animated: false, completion: nil)
            hasShownIntro = true
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        homeViewController = DogeHomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        picFeedViewController = PicFeedViewController()
        statsViewController = StatsViewController()

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        homeViewController = DogeHomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        picFeedViewController = PicFeedViewController()
        statsViewController = StatsViewController()

        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let homeImage = #imageLiteral(resourceName: "home-deselected")
        let homeBarItem = UITabBarItem(title: "Home",
                                         image: homeImage,
                                         selectedImage: nil)
        homeViewController.tabBarItem = homeBarItem
        
        let calendarImage = #imageLiteral(resourceName: "calednar-deselected")
        let picFeedBarItem = UITabBarItem(title: "Book",
                                          image: calendarImage,
                                          selectedImage: nil)
        picFeedViewController.tabBarItem = picFeedBarItem
        
        let statsImage = #imageLiteral(resourceName: "stats-deselected")
        let statsFeedBarItem = UITabBarItem(title: "Stats",
                                            image: statsImage,
                                          selectedImage: nil)
        statsViewController.tabBarItem = statsFeedBarItem

        self.viewControllers = [homeViewController, picFeedViewController, statsViewController]
    }
    
}
