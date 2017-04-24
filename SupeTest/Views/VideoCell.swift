//
//  VideoCell.swift
//  SupeTest
//
//  Created by Ramana Reddy on 23/04/2017.
//  Copyright © 2017 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

class VideoCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    func loadImage(urlString: String) {
        
        let imageUrl = URL(string: urlString.replacingOccurrences(of: "http:", with: "https:"))!
        DispatchQueue.global(qos: .background).async {
            if let imageData = NSData(contentsOf: imageUrl as URL) {
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    self.imgThumbnail.image = image
                    self.imgThumbnail.contentMode = UIViewContentMode.scaleAspectFit
                }
            }
            
        }
    }
}
