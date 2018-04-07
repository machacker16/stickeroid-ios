//
//  STRequest.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 8/2/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import Foundation

class STRequest {
    
    var lastSearchQuery: String?

    func getResourceWithSearchQuery(_ query: String, callback: @escaping (_ data: Data?) -> Void) {
        lastSearchQuery = query
        
        let requestUrl = STRequest.buildStickerRequestURL(searchQuery: query) // TODO: add guard
        requestStickerByURL(requestUrl, callback: callback);
    }
    
    func requestNextStickerFromLastSession(callback: @escaping (_ data: Data?) -> Void) {
        guard let searchQuery = lastSearchQuery else {
            print("Can't get next resource: no search was performed before.")
            return
        }
        
        let nextRequestParams = [
            RequestConstants.RequestKeys.NextQuery: RequestConstants.RequestValues.NextQuery
        ]
        let requestUrl = STRequest.buildStickerRequestURL(searchQuery: searchQuery, additionalParams: nextRequestParams)
        
        requestStickerByURL(requestUrl, callback: callback);
    }

    func requestPreviousStickerFromLastSession(callback: @escaping (_ data: Data?) -> Void) {
        guard let searchQuery = lastSearchQuery else {
            print("Can't get previous resource: no search was performed before.")
            return
        }
        
        let previousRequestParams = [
            RequestConstants.RequestKeys.PreviousQuery: RequestConstants.RequestValues.PreviousQuery
        ]
        let requestUrl = STRequest.buildStickerRequestURL(searchQuery: searchQuery, additionalParams: previousRequestParams)
        
        requestStickerByURL(requestUrl, callback: callback);
    }
    
    func requestStickerByURL(_ url: URL, callback: @escaping (_ data: Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard (error == nil) else {
                print(error!)
                return
            }
            callback(data)
        }.resume()
    }
    
    static func buildStickerRequestURL(searchQuery: String, additionalParams: [String: String]? = nil) -> URL {
        var resourceRequestParams = [
            RequestConstants.RequestKeys.SecretKey: RequestConstants.RequestValues.SecretKey,
            RequestConstants.RequestKeys.SearchQuery: searchQuery
        ]
        
        if let additionalParams = additionalParams {
            for (key, value) in additionalParams {
                resourceRequestParams[key] = value
            }
        }
        
        let requestUrl = stickeroidUrlFromParameters(parameters: resourceRequestParams as [String:AnyObject])
        return requestUrl
    }
    
    static func stickeroidUrlFromParameters(parameters: [String:AnyObject]) -> URL {
        var components = URLComponents()
        
        components.scheme = RequestConstants.APIScheme
        components.host = RequestConstants.APIHost
        components.path = RequestConstants.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
}
