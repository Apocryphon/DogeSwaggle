//
//  IntroViewController.swift
//  DogeSwaggle
//
//  Created by Aaron Jubbal on 10/3/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, DogeSelectionTableViewControllerDelegate {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        signUpButton.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
        signUpButton.layer.cornerRadius = 8
        loginButton.backgroundColor = UIColor.Purple.dark
        loginButton.layer.cornerRadius = 8
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        print("\(#function)")
        
        showDogSelection()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("\(#function)")
        
        showDogSelection()
    }
    
    func showDogSelection() -> Void {
//        if UserDefaults.standard.string(forKey: "dogType") != nil {
//            self.dismiss(animated: true, completion: nil)
//        } else {
            let dogeSelectionController = DogeSelectionTableViewController(nibName: "DogeSelectionTableViewController", bundle: nil)
            dogeSelectionController.delegate = self
            let navigationController = UINavigationController(rootViewController: dogeSelectionController)
            if #available(iOS 13.0, *) {
                navigationController.isModalInPresentation = true
            }
            self.present(navigationController, animated: true, completion: nil)
            return;
//        }
    }
    
    func didDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
