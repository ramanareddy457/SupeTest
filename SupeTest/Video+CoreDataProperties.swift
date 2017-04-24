//
//  Video+CoreDataProperties.swift
//  SupeTest
//
//  Created by Ramana Reddy on 24/04/2017.
//  Copyright © 2017 Ramana Reddy. All rights reserved.
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video")
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var videoId: String?
    @NSManaged public var isSearchResult: Bool

}
