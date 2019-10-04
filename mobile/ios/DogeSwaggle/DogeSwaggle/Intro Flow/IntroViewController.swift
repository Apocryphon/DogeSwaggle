//
//  IntroViewController.swift
//  DogeSwaggle
//
//  Created by Aaron Jubbal on 10/3/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
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
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("\(#function)")
    }
    
}
