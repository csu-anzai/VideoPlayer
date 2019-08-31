//
//  VideoInfo.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/30.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import Foundation

/// Contains all needed info about a certain video.
struct VideoInfo: Codable {
    
    private enum Keys: String, CodingKey, CaseIterable {
        case title = "title"
        case presenterName = "presenter_name"
        case description = "description"
        case thumbnailURLString = "thumbnail_url"
        case videoURLString = "video_url"
        case videoDuration = "video_duration"
    }
    
    /// Video title.
    let title: String
    /// Presenter name.
    let presenterName: String
    /// Description of video.
    let description: String
    /// Video duration in seconds.
    let videoDuration: Int
    /// thumbnail url string.
    private let thumbnailURLString: String
    /// video url string.
    private let videoURLString: String
    
    /// Video thumbnail url.
    var thumbnailURL: URL? {
        return URL(string: thumbnailURLString)
    }
    
    /// Video url.
    var videoURL: URL? {
        return URL(string: videoURLString)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        Keys.allCases.forEach { key in
            
        }
        title = try container.decode(String.self, forKey: .title)
        presenterName = try container.decode(String.self, forKey: .presenterName)
        description = try container.decode(String.self, forKey: .description)
        thumbnailURLString = try container.decode(String.self, forKey: .thumbnailURLString)
        videoURLString = try container.decode(String.self, forKey: .videoURLString)
        videoDuration = try container.decode(Int.self, forKey: .videoDuration)
        
    }
}
