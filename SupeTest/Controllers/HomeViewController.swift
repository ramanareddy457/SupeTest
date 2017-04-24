//
//  ViewController.swift
//  SupeTest
//
//  Created by Ramana Reddy on 23/04/2017.
//  Copyright © 2017 Ramana Reddy. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var videosCollectionView: UICollectionView!
    var pageNumber = 1
    let refreshControl = UIRefreshControl()
    var fetchedResultsController: NSFetchedResultsController<Video>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        fetchVideos()
        if #available(iOS 10.0, *) {
            videosCollectionView.refreshControl = refreshControl
        } else {
            videosCollectionView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching more videos ...", attributes: nil)
        refreshControl.addTarget(self, action: #selector(HomeViewController.fetchVideos), for: .valueChanged)
    }
    
    func fetchVideos() {
        ApiManager.shared.fetchVideos{ success in
            self.refreshControl.endRefreshing()
            if success {
                self.reloadData()
            }
        }
    }
    
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let fetchRequest:NSFetchRequest<Video> = Video.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isSearchResult == NO")
        let sortDescriptor = NSSortDescriptor(key: "videoId", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: appDelegate.persistentContainer.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            videosCollectionView.reloadData()
        } catch let error {
            print(error)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VideoCell.self), for: indexPath) as! VideoCell
            let item = fetchedResultsController.object(at: indexPath)
            cell.lblTitle.text = item.title
            cell.loadImage(urlString: item.imageUrl!)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoVC = storyboard.instantiateViewController(withIdentifier :String(describing:VideoViewController.self)) as! VideoViewController
        let item = fetchedResultsController.object(at: indexPath)
        videoVC.videoID = item.videoId
        if UIDevice.current.userInterfaceIdiom == .pad {
            videoVC.modalPresentationStyle = .formSheet
        }
        present(videoVC, animated: true, completion: nil)
    }
}
