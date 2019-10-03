//
//  FirstViewController.swift
//  DogeSwaggle
//
//  Created by Richard Yeh on 10/2/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let dogType = UserDefaults.standard.string(forKey: "dogType") else {
            let viewController = DogeSelectionTableViewController(nibName: "DogeSelectionTableViewController", bundle: nil)
            let navigationController = UINavigationController(rootViewController: viewController)
            if #available(iOS 13.0, *) {
                navigationController.isModalInPresentation = true
            }
            self.present(navigationController, animated: true, completion: nil)
            return;
        }
    }


}

