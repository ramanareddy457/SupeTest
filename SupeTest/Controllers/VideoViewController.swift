//
//  VideoViewController.swift
//  SupeTest
//
//  Created by Ramana Reddy on 23/04/2017.
//  Copyright © 2017 Ramana Reddy. All rights reserved.
//

import UIKit
import DailymotionPlayerSDK

class VideoViewController: UIViewController {
    @IBOutlet private var containerView: UIView!
    var videoID: String?
    
    private lazy var playerViewController: DMPlayerViewController = {
        let parameters: [String: Any] = [
            "fullscreen-action": "trigger_event", // Trigger an event when the users toggles full screen mode in the player
            "sharing-action": "trigger_event" // Trigger an event to share the video to e.g. show a UIActivityViewController
        ]
        let controller = DMPlayerViewController(parameters: parameters)
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerViewController()
        if videoID != nil {
            playerViewController.load(videoId: videoID!)
        }
    }
    
    private func setupPlayerViewController() {
        addChildViewController(playerViewController)
        
        let view = playerViewController.view!
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        // Make the player's view fit our container view
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            view.topAnchor.constraint(equalTo: containerView.topAnchor),
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
    }
    
}

extension VideoViewController: DMPlayerViewControllerDelegate {
    func player(_ player: DMPlayerViewController, openUrl url: URL) {
        // Sent when a user taps on an ad that can display more information
    }
    
    func player(_ player: DMPlayerViewController, didReceiveEvent event: PlayerEvent) {
        switch event {
        case .namedEvent(let name, _) where name == "fullscreen_toggle_requested":
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}
