//
//  URLSessionProvider.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/30.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import Foundation

/// This protocol is used to create an interface layer between the URLRequests.
/// and the network.
///
/// By adapting this protocol you can create dummy servers that don't actually.
/// need internet connection to test your app logic.
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> ()
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}


/// Main interface between URLRequests and the network.
///
/// Use this class to make network request. Fetching, sending,
/// updating data.
final class URLSessionProvider: NSObject {
    
    /// Events that URLSessionProvider Emits during its lifetime.
    enum Event<T> {
        /// Started execution of request.
        case startedLoading
        /// Progress percentage of request.
        case progressPercentage(Double)
        /// Finished execution of request. This is called regardles of success or error.
        case finishedLoading
        /// Request succeded with Data.
        case success(T)
        /// Error event with the specific error.
        case error(Error)
    }
    
    /// Error Cases for URLSessionProvider
    enum URLSessionProviderError: Error {
        /// No network Error.
        case noNetwork
        /// Received an empty response with no error.
        case emptyResponse
        /// Error while trying to decode json file.
        case jsonDecodingFailed
        /// General puropose error case for all unkown errors.
        case unkown
    }
    
    // Internal session object
    private var session: URLSessionProtocol
    // Used to track progress of request
    private var progressObserver: NSKeyValueObservation!
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    /// Initiate a network request.
    ///
    /// - Parameters:
    ///   - service: The Service/API to use for the request.
    ///   - completion: Completion handler for the response.
    func request<T:Decodable>(service: ServiceProtocol, listen listener: @escaping (Event<T>)->()) {
        listener(.startedLoading)
        
        // setup request
        let request = URLRequest(service: service)
        let task = session.dataTask(request: request) { [weak self] (data, urlResponse, error) in
            let httpResponse = urlResponse as? HTTPURLResponse
            URLSessionProvider.handleResponse(data: data, response: httpResponse, error: error, listen: listener)
            listener(.finishedLoading)
            self?.progressObserver = nil // make sure to nullify to stop listening
        }
        
        // listen for progress
        progressObserver = task.progress.observe(\.fractionCompleted) { (progress, _) in
            listener(Event.progressPercentage(progress.fractionCompleted))
        }
        
        // initiate request
        task.resume()
    }
    
    private class func handleResponse<T: Decodable>(data: Data?,
                                                        response: HTTPURLResponse?,
                                                        error: Error?,
                                                        listen listener: @escaping (Event<T>)->()) {
        guard error == nil else {
            listener(.error(error!))
            return
        }
        
        guard let response = response else {
            listener(.error(URLSessionProviderError.emptyResponse))
            return
        }
        
        switch response.statusCode {
        case 200...299:
            guard let data = data else {
                listener(.error(URLSessionProviderError.unkown))
                break
            }
            if let data = data as? T { // in case required type<T> is Data (e.g: video)
                listener(.success(data))
                break
            } else if let model = try? JSONDecoder().decode(T.self, from: data) { // decode json
                listener(.success(model))
            } else { // json decoding failed
                listener(.error(URLSessionProviderError.jsonDecodingFailed))
            }
        default:
            listener(.error(URLSessionProviderError.unkown))
        }
    }
    
}
