//
//  URLRequest+Additions.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/30.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import Foundation

extension URLComponents {
    init(service: ServiceProtocol) {
        let url = service.baseURL.appendingPathComponent(service.path)
        self.init(url: url, resolvingAgainstBaseURL: false)! // Allow crashes here to catch setup problems asap.
        
        guard service.parametersEncoding == .url, !service.parameters.isEmpty else {
            return
        }
        
        queryItems = service.parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
        
    }
}

extension URLRequest {
    init(service: ServiceProtocol) {
        let urlComponents = URLComponents(service: service)
        
        self.init(url: urlComponents.url!)
        
        httpMethod = service.method.rawValue
        service.headers.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }
        
        guard service.parametersEncoding == .json, !service.parameters.isEmpty else {
            return
        }
        
        httpBody = try? JSONSerialization.data(withJSONObject: service.parameters)
    }
}
