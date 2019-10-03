//
//  PicFeedViewController.swift
//  DogeSwaggle
//
//  Created by Richard Yeh on 10/2/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import UIKit

 class PicFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    private let reuseIdentifier = "kPupCell"
    private let itemsPerRow: CGFloat = 3
     
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    
    private var imageUrls = [String?]()

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
                }
            } catch {
                
            }
        }
        task.resume()
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
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PupPicCollectionViewCell
        cell.backgroundColor = .black 
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
    return sectionInsets.left
  }
}

