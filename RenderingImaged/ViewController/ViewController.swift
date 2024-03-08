//
//  ViewController.swift
//  RenderingImaged
//
//  Created by Maktumhusen on 08/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var users: [User]?
    
    private let url = "https://reqres.in/api/users?page=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// Set Delegate & Data soure to viewController
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// download user data
        let downloader = DataDownloader()
        
        guard let urlString = URL(string: url) else { return }
        downloader.getUserData(url: urlString) { result in
            _ = result.map { [weak self] userData in
                self?.users = userData
            }
        }
    }
    
    /// Detects scrollview decelrating
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.collectionView.frame.size.width - 40
        pageControl.currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
    }
}

/// Collection View Data Source Methods
extension ViewController: UICollectionViewDataSource {
    
    /// returns number of items in section
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = self.users?.count ?? 0
        pageControl.isHidden = (self.users?.count == 1)
        return self.users?.count ?? 0
    }
    
    /// returns cell items at indexPath
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        let dummyCell = UICollectionViewCell.init()
        guard let user = self.users?[indexPath.item] else { return dummyCell}
        cell.setupData(userData: user)
        return cell
    }
}

/// Collection View Delegate Flow Layout Methods
extension ViewController: UICollectionViewDelegateFlowLayout {

    /// return minimun space between sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }

    /// return size for item at indexPath
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frameSize = collectionView.frame.size
        return CGSize(width: view.frame.width, height: frameSize.height)
    }

    /// return edge Insets for each section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
