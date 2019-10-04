//
//  DogeHomeViewController.swift
//  DogeSwaggle
//
//  Created by Korin Wong-Horiuchi on 10/3/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import Foundation
import UIKit

enum DogCategory: Int {
    case HeaderQuestion, Restaurants, Destinations, Hotels, Clinics
    
    var name: String {
        switch self {
        case .HeaderQuestion:
            return "How can we help, Elle?"
        case .Restaurants:
            return "Dog Friendly Restaurants"
        case .Destinations:
            return "Pet Friendly Destinations"
        case .Hotels:
            return "Pet Friendly Hotels"
        case .Clinics:
            return "Pet Clinics"
        }
    }
    
    var imageNames: [String] {
        switch self {
        case .Restaurants:
            return ["Outerlands", "Skool", "Surisan"]
        case .Destinations:
            return ["Hong Kong flight", "Seattle Flight", "Amsterdam flight"]
        case .Hotels:
            return ["Grand Hyatt SF", "Hotel Abri"]
        case .Clinics:
            return ["Outerlands", "Skool", "Surisan"]
        default:
            return []
        }
    }
}

extension DogeHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch DogCategory(rawValue: indexPath.section)! {
        case .HeaderQuestion:
            return CGSize(width: collectionView.frame.width, height: 40)
        case .Restaurants:
            return CGSize(width: collectionView.frame.width, height: indexPath.row == 0 ? 176 : 374)
        case .Destinations:
            return CGSize(width: collectionView.frame.width, height: 190)
        case .Hotels:
            return CGSize(width: collectionView.frame.width, height: 176)
        case .Clinics:
            return CGSize(width: collectionView.frame.width, height: 246)
        }
    }
}

class DogeHomeViewController: UICollectionViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        self.setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 50)
        self.collectionView.collectionViewLayout = layout

        self.view.backgroundColor = .white
        collectionView.register(QuestionHeader.self, forCellWithReuseIdentifier: "questionHeader")
        collectionView.register(ImageHeader.self, forCellWithReuseIdentifier: "imageHeader")
        collectionView.register(DogCollectionCell.self, forCellWithReuseIdentifier: "rowCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionHeader", for: indexPath) as! QuestionHeader
            return cell
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageHeader", for: indexPath) as! ImageHeader
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rowCell", for: indexPath) as! DogCollectionCell
            cell.dogCategory = DogCategory(rawValue: indexPath.section)
            cell.setupStack()
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (DogCategory(rawValue: section)) {
        case .Restaurants:
            return 2
        case .Destinations:
            return 1
        case .Hotels:
            return 1
        case .Clinics:
            return 1
        default:
            print("no dog")
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView {
            headerView.backgroundColor = .white
            let category = DogCategory(rawValue: indexPath.section) ?? .Restaurants
            headerView.label.text = category.name
            return headerView
        }
        return UICollectionReusableView()
    }
}

class DogCollectionCell: UICollectionViewCell {
    var dogCategory: DogCategory?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStack() {
        let scroller = DogScroll(frame: self.frame)
        let category = dogCategory ?? .Restaurants
        self.contentView.addSubview(scroller)
        scroller.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        for name in category.imageNames {
            let view = UIImageView(image: UIImage(named: name))
            view.frame = CGRect(x: 0, y: 0, width: view.intrinsicContentSize.width, height: view.intrinsicContentSize.height)
            view.contentMode = .scaleAspectFit
            scroller.stackView.addArrangedSubview(view)
        }
    }
}

class DogScroll: UIScrollView {
    
    var category: DogCategory?
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.backgroundColor = .white
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.backgroundColor = .white
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        addSubview(stackView)
        stackView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
}

class HeaderView: UICollectionReusableView {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .black
       return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(label)
        label.frame = CGRect(x: 10, y: 0, width: self.frame.width, height: self.frame.height)
    }
}

class ImageHeader: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageView = UIImageView(image: UIImage(named: "pet-destinations"))
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 374)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QuestionHeader: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.text = "How can we help, Elle?"
       return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(label)
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height:30)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
