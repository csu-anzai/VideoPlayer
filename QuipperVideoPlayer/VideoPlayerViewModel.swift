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
    
    // TODO: Add download (save) feature ↓↓↓↓ This is to fetch video data and then maybe cache it somehow
//    typealias Listener = (Data)->()
//    /// Callback to receive the video data
//    var fetchedVideoData: Listener? {
//        didSet { // publish data if available right away.
//            publishVideoData()
//        }
//    }
//    private var videoData: Data? {
//        didSet {
//            publishVideoData()
//            // TODO: Cache data with url as the key
//        }
//    }
//
//    private func publishVideoData() {
//        guard let videoData = videoData else {
//            return
//        }
//        fetchedVideoData?(videoData)
//    }
//
//    private func fetchVideoData() {
//        // TODO: Fetch from cache first, if none exist fetch from service
//        guard let url = videoInfo.videoURL else {
//            print("Video url wasn't found!") // TODO: Handle this case. (e.g: show an error dialog)
//            return
//        }
//        let service = DataService(baseURL: url)
//        let session = URLSessionProvider()
//        session.request(service: service) { (event: URLSessionProvider.Event<Data>) in
//            switch event {
//            case .startedLoading:
//                fallthrough
//            case .progressPercentage(_):
//                fallthrough
//            case .finishedLoading:
//                // TODO: Handle loading progress
//                break
//            case .success(let data):
//                self.videoData = data
//            case .error(let error):
//                print("\(error.localizedDescription)") // TODO: Handle errors.
//            }
//        }
//    }
    
    
}
