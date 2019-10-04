//
//  DogeHomeViewController.swift
//  DogeSwaggle
//
//  Created by Korin Wong-Horiuchi on 10/3/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

enum DogCategory: Int, CaseIterable {
    case HeaderQuestion, Restaurants, Destinations, Hotels, Parks, Clinics
    
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
        case .Parks:
            return "Dog Parks"
        case .Clinics:
            return "Pet Clinics"
        }
    }
    
    var imageNames: [String] {
        switch self {
        case .Restaurants:
            return ["Outerlands", "Skool", "Surisan"]
        case .Destinations:
            return ["NYC", "Hong Kong flight", "Seattle Flight", "Amsterdam flight"]
        case .Hotels:
            return ["Grand Hyatt SF", "Hotel Abri"]
        case .Parks:
            return ["Park1", "Park2", "Park3", "Park4"]
        case .Clinics:
            return ["Clinic1", "Clinic2", "Clinic3"]
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
            return CGSize(width: collectionView.frame.width, height: 400)
        case .Hotels:
            return CGSize(width: collectionView.frame.width, height: 176)
        case .Parks:
            return CGSize(width: collectionView.frame.width, height: 400)
        case .Clinics:
            return CGSize(width: collectionView.frame.width, height: indexPath.row == 0 ? 176 : 374)
        }
    }
}

class DogeHomeViewController: UICollectionViewController {
    
    private var parks = [Park]()
    private var clinics = [Clinic]()

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
        collectionView.register(DogCollectionBoxCell.self, forCellWithReuseIdentifier: "boxCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDogParks()
        getPetClinics()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionHeader", for: indexPath) as! QuestionHeader
            return cell
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageHeader", for: indexPath) as! ImageHeader
            return cell
        }
        if indexPath.section == DogCategory.Destinations.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boxCell", for: indexPath) as! DogCollectionBoxCell
            cell.dogCategory = DogCategory(rawValue: indexPath.section)
            cell.setupStack()
            return cell
        }
        if indexPath.section == DogCategory.Parks.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boxCell", for: indexPath) as! DogCollectionBoxCell
            cell.dogCategory = DogCategory(rawValue: indexPath.section)
            cell.models = self.parks
            cell.setupStack()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rowCell", for: indexPath) as! DogCollectionCell
            cell.dogCategory = DogCategory(rawValue: indexPath.section)
            if indexPath.section == DogCategory.Clinics.rawValue {
                cell.models = self.clinics
            }
            cell.setupStack()
            return cell
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DogCategory.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (DogCategory(rawValue: section)) {
        case .Restaurants:
            return 2
        case .Destinations:
            return 1
        case .Hotels:
            return 1
        case .Parks:
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

extension DogeHomeViewController {
    // MARK: - Kinship API
    func getDogParks() {
        let getDogParksUrl = URL(string:"https://kinship-fd251.firebaseapp.com/api/v1/dog-parks")!
        let task = URLSession.shared.dataTask(with: getDogParksUrl) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }

            do {
                let parkResponse = try JSONDecoder().decode([Park].self, from: data)
                if parkResponse.count >= 4 {
                    self.parks = Array(parkResponse.prefix(4))
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                
            }
        }
        task.resume()
    }
    
    func getPetClinics() {
        let getClinicsUrl = URL(string:"https://kinship-fd251.firebaseapp.com/api/v1/banfield-locations/")!
        let task = URLSession.shared.dataTask(with: getClinicsUrl) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }

            do {
                let clinicalResponse = try JSONDecoder().decode([Clinic].self, from: data)
                if clinicalResponse.count >= 3 {
                    self.clinics = Array(clinicalResponse.prefix(3))
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                
            }
        }
        task.resume()

    }
}

class DogCollectionCell: UICollectionViewCell {
    var dogCategory: DogCategory?
    var models: [Any?]

    let mosconeCoordinates = CLLocation(latitude: 37.783863055111, longitude: 122.401261925697)
    
    override init(frame: CGRect) {
        models = []
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

        for (index, name) in category.imageNames.enumerated() {
            let view = UIImageView(image: UIImage(named: name))
            view.frame = CGRect(x: 0, y: 0, width: view.intrinsicContentSize.width, height: view.intrinsicContentSize.height)
            view.contentMode = .scaleAspectFit
            scroller.stackView.addArrangedSubview(view)
            
            if category.rawValue == DogCategory.Clinics.rawValue {
                guard models.count > 0 else { return }

                // todo: placeholders?
                if let clinic = models[index] as? Clinic {
                    let nameLabel = UILabel(frame: view.frame)
                    nameLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
                    nameLabel.textColor = UIColor.white
                    nameLabel.center = CGPoint(x: view.frame.minX + view.frame.size.width / 2, y: view.frame.minY + view.frame.size.height * 0.75)
                    nameLabel.numberOfLines = 0
                    nameLabel.textAlignment = NSTextAlignment.center

                    nameLabel.text = clinic.location
                    view.addSubview(nameLabel)

                    if let docLat = Double(clinic.latitude), let docLong = Double(clinic.longitude) {
                        let docCoordinates = CLLocation(latitude: docLat, longitude: docLong)
                        let distance = mosconeCoordinates.distance(from: docCoordinates) * 0.0000001
                        let distanceLabel = UILabel(frame: view.frame)
                        distanceLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
                        distanceLabel.textColor = UIColor.white
                        distanceLabel.center = CGPoint(x: nameLabel.center.x, y: view.frame.minY + view.frame.size.height * 0.75 + 18.0)
                        distanceLabel.numberOfLines = 0
                        distanceLabel.textAlignment = NSTextAlignment.center
                        let milesAway: String = String(format:"%.1f", distance)
                        distanceLabel.text = "\(milesAway) mi."
                        view.addSubview(distanceLabel)
                    }
                }
            }
        }
    }
}

class DogCollectionBoxCell: DogCollectionCell {
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height * 2 + 50))
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupStack() {
        let category = dogCategory ?? .Restaurants
        
        for (index, name) in category.imageNames.enumerated() {
            let view = UIImageView(image: UIImage(named: name))
            view.contentMode = .scaleAspectFit
            
            let fixedMargin = 15
            let fixedWidth = 168
            let fixedHeight = 190
            let fixedSpace = 10
            
            switch index {
            case 0:
                view.frame = CGRect(x: fixedMargin, y: 0, width: fixedWidth, height: fixedHeight)
            case 1:
                view.frame = CGRect(x: fixedMargin + fixedWidth + fixedSpace, y: 0, width: fixedWidth, height: fixedHeight)
            case 2:
                view.frame = CGRect(x: fixedMargin, y: fixedHeight + fixedSpace, width: fixedWidth, height: fixedHeight)
            default:
                view.frame = CGRect(x: fixedMargin + fixedWidth + fixedSpace, y: fixedHeight + fixedSpace, width: fixedWidth, height: fixedHeight)
            }
            self.contentView.addSubview(view)
            
            if category.rawValue == DogCategory.Parks.rawValue {
                guard models.count > 0 else { return }

                // todo: placeholders?
                if let park = models[index] as? Park {
                    let nameLabel = UILabel(frame: view.frame)
                    nameLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
                    nameLabel.textColor = UIColor.white
                    nameLabel.center = CGPoint(x: view.frame.minX + view.frame.size.width / 2, y: view.frame.minY + view.frame.size.height * 0.75)
                    nameLabel.numberOfLines = 0
                    nameLabel.textAlignment = NSTextAlignment.center

                    nameLabel.text = park.name
                    self.contentView.addSubview(nameLabel)

                    if let parkLat = Double(park.latitude), let parkLong = Double(park.longitude) {
                        let parkCoordinates = CLLocation(latitude: parkLat, longitude: parkLong)
                        let distance = mosconeCoordinates.distance(from: parkCoordinates) * 0.0000001
                        let distanceLabel = UILabel(frame: view.frame)
                        distanceLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
                        distanceLabel.textColor = UIColor.white
                        distanceLabel.center = CGPoint(x: nameLabel.center.x, y: view.frame.minY + view.frame.size.height * 0.75 + 18.0)
                        distanceLabel.numberOfLines = 0
                        distanceLabel.textAlignment = NSTextAlignment.center
                        let milesAway: String = String(format:"%.1f", distance)
                        distanceLabel.text = "\(milesAway) mi."
                        self.contentView.addSubview(distanceLabel)
                    }
                }
            }
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
        self.contentSize = CGSize(width: frame.width + 100, height: frame.height)
        self.showsHorizontalScrollIndicator = false
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
        imageView.frame = CGRect(x: 15.0, y: 15.0, width: frame.width - 30.0, height: frame.height)
        imageView.contentMode = .scaleAspectFill
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
