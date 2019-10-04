//
//  ProfileViewController.swift
//  DogeSwaggle
//
//  Created by Richard Yeh on 10/4/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textBlock: UIImageView!
    
    public let type: String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == "trending" {
            self.profileImageView.image = UIImage(named: "Ellie-Mae")
            self.textBlock.image = UIImage(named: "Ellie-text")
        }
        else if type == "playdates" {
            self.profileImageView.image = UIImage(named: "Sophie")
            self.textBlock.image = UIImage(named: "Sophie-text")
        }
    }
    
    init(typeString: String) {
        type = typeString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}
