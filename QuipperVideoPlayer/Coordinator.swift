//
//  Coordinator.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/31.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import Foundation

final class Coordinator {
    
    // the coordinator lives for as long as the rootViewController so no nead for weak here.
    let rootViewController: VideoListViewController
    
    init(rootViewController: VideoListViewController) {
        self.rootViewController = rootViewController
    }
    
}

extension Coordinator: VideoListViewControllerDelegate {
    func didSelect(_ videoInfo: VideoInfo, viewController: VideoListViewController) {
        // TODO: Add custom transition animation
        let playerViewModel = VideoPlayerViewModel(videoInfo: videoInfo)
        let vc = VideoPlayerViewController(viewModel: playerViewModel)
        viewController.present(vc, animated: true, completion: nil)
    }
}
