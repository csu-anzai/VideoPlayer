//
//  VideoPlayerViewModel.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/09/01.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import Foundation

class VideoPlayerViewModel {
    
    private let videoInfo: VideoInfo
    
    init(videoInfo: VideoInfo) {
        self.videoInfo = videoInfo
    }
    
    var videoURL: URL? {
        return videoInfo.videoURL
    }
    
}
