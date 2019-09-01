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
    
    func videoDescription(at indexPath: IndexPath) -> String {
        let videoInfo = videosInfo[indexPath.row]
        return videoInfo.description
    }
    
    func videoDuration(at indexPath: IndexPath) -> String {
        let videoInfo = videosInfo[indexPath.row]
        return String.stringRepresentationOfDuration(milliseconds: videoInfo.videoDuration)
    }
    
    func videoThumbnailURL(at indexPath: IndexPath) -> URL? {
        let videoInfo = videosInfo[indexPath.row]
        return videoInfo.thumbnailURL
    }
    
}

private extension String {
    /// Converts a given duration into a string representation.
    ///
    /// For example:
    ///
    ///     let milliseconds = 104000
    ///     print(String.stringRepresentationOfDuration(milliseconds: milliseconds))
    ///     // Output: 1:44
    /// - Parameter milliseconds: The duration to be converted in milliseconds.
    /// - Returns: The string representation of the given duration.
    static func stringRepresentationOfDuration(milliseconds: Int) -> String {
        let minutes = milliseconds/1000/60
        let seconds = Int(Double(milliseconds/1000).truncatingRemainder(dividingBy: 60))
        let twoDigitSecondsString: String = twoDigitRepresentation(number: seconds)
        return "\(minutes):\(twoDigitSecondsString)"
    }
    
    private static func twoDigitRepresentation(number: Int) -> String {
        if isSingleDigit(number: number) {
            return "0\(number)"
        } else {
            return "\(number)"
        }
    }
    
    private static func isSingleDigit(number: Int) -> Bool {
        return number/10 == 0
    }
}
