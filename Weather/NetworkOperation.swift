//
//  NetworkOperation.swift
//  Weather
//
//  Created by Brexton Pham on 7/5/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

import Foundation

class NetworkOperation {
    
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void
    
    init(url: NSURL) {
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            // Check HTTP response for successful GET request
            
            if let httpResponse = response as? NSHTTPURLResponse {
                
                switch(httpResponse.statusCode) {
                case 200:
                    // Create JSON object w/ data
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject]
                    completion(jsonDictionary)
                default:
                    println("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
                
            } else {
                println("Error: Not a valid HTTP response")
            }
        }
        
        dataTask.resume()
        
    }
}
