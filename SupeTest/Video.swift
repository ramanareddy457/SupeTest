//
//  Video+CoreDataClass.swift
//  SupeTest
//
//  Created by Ramana Reddy on 23/04/2017.
//  Copyright © 2017 Ramana Reddy. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Video)
public class Video: NSManagedObject {
    
    class func createVideoObject(videoDict: [String:String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if let videoId = videoDict["id"] {
            let video = Video(entity: Video.entity(), insertInto: appDelegate.persistentContainer.viewContext)
            video.videoId = videoId
            video.title = videoDict["title"] ?? ""
            if let imgUrl = videoDict["thumbnail_120_url"] {
                video.imageUrl = imgUrl
            } else {
                video.imageUrl = videoDict["thumbnail_url"] ?? ""
                video.isSearchResult = true
            }
        }
    }
}
