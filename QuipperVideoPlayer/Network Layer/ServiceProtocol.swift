//
//  ServiceProtocol.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/28.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import Foundation

/// All possible HTTP methods.
///
/// - get: Retrieve data Request.
/// - post: Submit Data Request.
/// - put: Update Request.
/// - delete: Delete Data Request.
enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Parameter encoding method for http requests.
///
/// - url: encode as a url.
/// - json: encode as a json.
enum HTTPRequestParametersEncoding {
    case url
    case json
}

/// The Abstract Servcie/API Protocol.
protocol ServiceProtocol {
    typealias Headers = [String: String]
    typealias Parameters = [String: Any]
    
    /// The base url for this service/api.
    var baseURL: URL { get }
    /// The specific path for this service/api.
    var path: String { get }
    /// The HTTP method used for this service/api.
    var method: HTTPRequestMethod { get }
    /// Headers for this service/api.
    var headers: Headers { get }
    /// Parameters for this service/api.
    var parameters: Parameters { get }
    /// Encoding type of the Parameters.
    var parametersEncoding: HTTPRequestParametersEncoding { get }
}
