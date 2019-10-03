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
            let viewController = DogeSelectionViewController(nibName: "DogeSelectionViewController", bundle: nil)
            if #available(iOS 13.0, *) {
                viewController.isModalInPresentation = true
            }
            self.present(viewController, animated: true, completion: nil)
            return;
        }
    }


}

