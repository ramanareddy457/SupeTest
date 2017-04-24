//
//  ApiManager.swift
//  SupeTest
//
//  Created by Ramana Reddy on 23/04/2017.
//  Copyright © 2017 Ramana Reddy. All rights reserved.
//

import Foundation
class ApiManager {
    static let shared = ApiManager()
    let featuredUrl = "https://api.dailymotion.com/videos?fields=id,thumbnail_120_url,title&flags=featured&page="
    let searchUrl = "https://api.dailymotion.com/videos?fields=id,thumbnail_url%2Ctitle&country=it&limit=50&search="
    var pageNumber = 1
    
    func fetchVideos(searchText: String = "", completion:@escaping (Bool)->()) {
        let scriptUrl: String
        if searchText == "" {
            scriptUrl = featuredUrl + "\(pageNumber)"
        } else {
            scriptUrl = searchUrl + "\(searchText)"
        }
        
        if let videoListUrl = URL(string: scriptUrl) {
            DispatchQueue.global(qos: .userInitiated).async {
                let task = URLSession.shared.dataTask(with: videoListUrl) {
                    data, response, error in
                    
                    // Check for error
                    if error != nil{
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                            if let arr = dict["list"] as? [[String:String]]{
                                DispatchQueue.main.async {
                                    self.pageNumber += 1
                                    for item in arr {
                                        Video.createVideoObject(videoDict: item)
                                    }
                                    completion(true)
                                }
                            }
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                task.resume()
            }
        }
    }
}
