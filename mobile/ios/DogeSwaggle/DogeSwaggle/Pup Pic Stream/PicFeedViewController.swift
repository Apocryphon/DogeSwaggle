//
//  PicFeedViewController.swift
//  DogeSwaggle
//
//  Created by Richard Yeh on 10/2/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import UIKit
import SDWebImage

enum PicFilter: Int {
    case Trending, DogSitters, PlayDates, Recent

    var placeholder: String {
        switch self {
        case .Trending:
            return "Trending"
        case .DogSitters:
            return "Dog sitters"
        case .PlayDates:
            return "Play dates"
        case .Recent:
            return "Recent"
        }
    }
}

 class PicFeedViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!

    private let reuseIdentifier = "kPupCell"
    private let itemsPerRow: CGFloat = 3
    
    let waitingGray = UIColor(red:0.90, green:0.89, blue:0.92, alpha:1.0)
     
    private let sectionInsets = UIEdgeInsets(top: 0.0,
                                             left: 15.0,
                                             bottom: 50.0,
                                             right: 15.0)
    
    private var imageUrls = [String?]()
    
    private var currentFilter = PicFilter.Trending

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self;
        collectionView.delegate = self;

        collectionView.register(UINib(nibName: "PupPicCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: reuseIdentifier)
        fetchDogImages()
     }
    
    // MARK: - Dog CEO API
    func fetchDogImages() {
        let randoDogImageUrl = URL(string:"https://dog.ceo/api/breeds/image/random/50")!
        let task = URLSession.shared.dataTask(with: randoDogImageUrl) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }

            do {
                let randoDogImageUrls = try JSONDecoder().decode(RandoDogImageResponse.self, from: data)
                DispatchQueue.main.async {
                    self.imageUrls = randoDogImageUrls.dogImageUrls
                    self.collectionView.reloadData()
                }
            } catch {

            }
        }
        task.resume()
    }
   
    // MARK: - UISegmentedControl
    @IBAction func filterControlDidChange(_ sender: UISegmentedControl) {
        let filterType = PicFilter(rawValue: sender.selectedSegmentIndex) ?? .Trending
        searchBar.placeholder = filterType.placeholder
        currentFilter = filterType
        fetchDogImages()
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isDogSitter = (currentFilter == .Trending && indexPath == IndexPath(item: 1, section: 0))
        let isPlaydate = (currentFilter == .PlayDates && indexPath == IndexPath(item: 7, section: 0))
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PupPicCollectionViewCell

        if isDogSitter || isPlaydate {
            if isDogSitter {
                cell.pupImageView.image = UIImage(named: "Ellie-Mae-thumb")
            }
            else {
                cell.pupImageView.image = UIImage(named: "Sophie-thumb")
            }
        }
        else {
            guard let dogImageUrlString = imageUrls[indexPath.row], let dogImageUrl = URL(string: dogImageUrlString)
                else { return cell }
            cell.pupImageView.sd_setImage(with: dogImageUrl,
                                          placeholderImage: nil)
        }

        cell.backgroundColor = waitingGray
        cell.pupImageView.contentMode = .scaleAspectFill

        return cell
    }
 }

// MARK: - Collection View Flow Layout Delegate
extension PicFeedViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
  }
}

// MARK: - Collection View Delegate

extension PicFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentFilter == .Trending && indexPath == IndexPath(item: 1, section: 0) {
            let profileViewController = ProfileViewController(typeString: "trending")
            self.present(profileViewController, animated: true, completion: nil)

        }
        else if currentFilter == .PlayDates && indexPath == IndexPath(item: 7, section: 0) {
            let profileViewController = ProfileViewController(typeString: "playdates")
            self.present(profileViewController, animated: true, completion: nil)
        }
    }
}
