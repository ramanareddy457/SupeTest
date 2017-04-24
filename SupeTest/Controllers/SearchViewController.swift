//
//  SearchViewController.swift
//  SupeTest
//
//  Created by Ramana Reddy on 23/04/2017.
//  Copyright © 2017 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchViewController: UIViewController {
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var fetchedResultsController: NSFetchedResultsController<Video>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        let keyboardGesture = UITapGestureRecognizer()
        keyboardGesture.numberOfTapsRequired = 1
        keyboardGesture.cancelsTouchesInView = false
        keyboardGesture.addTarget(self, action: #selector(SearchViewController.handleKeyboardGesture(gesture:)))
        view.addGestureRecognizer(keyboardGesture)
    }
    func handleKeyboardGesture(gesture keyboardGesture: UIGestureRecognizer) {
        view.endEditing(true)
    }
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let fetchRequest:NSFetchRequest<Video> = Video.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isSearchResult == YES")
        if searchBar.text != nil {
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        }
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

extension SearchViewController: UICollectionViewDataSource {
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

extension SearchViewController: UICollectionViewDelegate {
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

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != nil {
            ApiManager.shared.fetchVideos(searchText: searchBar.text!){ success in
                if success {
                    self.reloadData()
                }
            }
        }
    }
}
