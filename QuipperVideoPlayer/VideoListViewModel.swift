//
//  VideoListViewModel.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/31.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import Foundation

class VideoListViewModel {
    
    typealias Listener = ()->()
    
    /// Callback for when data has changed.
    var dataChanged: Listener?
    
    private var videosInfo: [VideoInfo] = []
    
    init() {
        // Initialize data from server.
        let service = QuipperVideoInfoService()
        let session = URLSessionProvider()
        session.request(service: service) { [weak self] (event: URLSessionProvider.Event<[VideoInfo]>) in
            switch event {
            case .startedLoading:
                fallthrough
            case .progressPercentage(_):
                fallthrough
            case .finishedLoading:
                // TODO: Handle loading.
                break
            case .success(let videosInfo):
                self?.videosInfo = videosInfo
                self?.dataChanged?()
            case .error(let error):
                print("\(error.localizedDescription)") // TODO: Handle Error.
            }
        }
    }
    
    func numberOfVideos() -> Int {
        return videosInfo.count
    }
    
    func videoInfo(at indexPath: IndexPath) -> VideoInfo {
        return videosInfo[indexPath.row]
    }
    
    func videoTitle(at indexPath: IndexPath) -> String {
        let videoInfo = videosInfo[indexPath.row]
        return videoInfo.title
    }
    
    func videoPresenterName(at indexPath: IndexPath) -> String {
        let videoInfo = videosInfo[indexPath.row]
        return videoInfo.presenterName
    }
    
    func videoDuration(at indexPath: IndexPath) -> String {
        let videoInfo = videosInfo[indexPath.row]
        let durationInSeconds = videoInfo.videoDuration/1000 // convert from ms to s
        let minutes = durationInSeconds / 60
        let seconds = Int(Double(durationInSeconds).truncatingRemainder(dividingBy: 60))
        return "\(minutes):\(seconds)"
    }
    
    func videoThumbnailURL(at indexPath: IndexPath) -> URL? {
        let videoInfo = videosInfo[indexPath.row]
        return videoInfo.thumbnailURL
    }
    
}
