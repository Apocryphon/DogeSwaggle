//
//  StatsViewController.swift
//  DogeSwaggle
//
//  Created by Aaron Jubbal on 10/3/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet var timeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeSegmentedControl.selectedSegmentIndex = 3
    }


    @IBAction func streakDisplayButtonTapped(_ sender: Any) {
        let viewController = IntroViewController(nibName: "IntroViewController", bundle: nil)
        if #available(iOS 13.0, *) {
            viewController.modalPresentationStyle = .fullScreen
        }
        self.present(viewController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
