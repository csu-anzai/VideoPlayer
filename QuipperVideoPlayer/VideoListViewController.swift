//
//  VideoListViewController.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/28.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import UIKit
import Cartography

protocol VideoListViewControllerDelegate: class {
    /// This is called when the user selects a specific Video.
    ///
    /// - Parameters:
    ///   - videoInfo: The selected video information object.
    ///   - viewController: The view controller in which the selection happend in.
    func didSelect(_ videoInfo: VideoInfo, viewController: VideoListViewController)
}

class VideoListViewController: UIViewController {

    weak var delegate: VideoListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

}

