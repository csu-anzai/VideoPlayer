//
//  DataService.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/09/01.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import Foundation

/// A data service that is used to request/download data from the web.
///
/// You only need to set the url (baseURL) of the specific data you want to download.
struct DataService: ServiceProtocol {
    let baseURL: URL
    
    let path: String = ""
    
    let method: HTTPRequestMethod = .get
    
    let headers: Headers = [:]
    
    let parameters: Parameters = [:]
    
    let parametersEncoding: HTTPRequestParametersEncoding = .url
}
