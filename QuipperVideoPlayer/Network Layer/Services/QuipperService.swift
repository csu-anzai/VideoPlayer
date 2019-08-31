//
//  QuipperService.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/09/01.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import Foundation

/// The main QuipperService class.
///
/// Subclass this class and override `path` and other properties
/// to adjust for a specific API.
class QuipperService: ServiceProtocol {
    let baseURL: URL = URL(string: "https://quipper.github.io/native-technical-exam/")!
    
    var path: String {
        return "playlist.json"
    }
    
    /// HTTP request method.
    ///
    /// Defualt is GET.
    var method: HTTPRequestMethod = .get
    
    var headers: Headers = [:]
    
    var parameters: Parameters = [:]
    
    var parametersEncoding: HTTPRequestParametersEncoding = .url
}

/// The specific Service/API to get Video list information.
class QuipperVideoInfoService: QuipperService {
    
    override var path: String {
        return "playlist.json"
    }
    
}
