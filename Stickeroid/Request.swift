//
//  STRequest.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 8/2/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import Foundation

fileprivate enum RequestType {
    case SearchAPI
    case BotAPI
}

class Request {
    
    var lastSearchQuery: String?

    // MARK: - Search API
    func requestSticker(_ query: String, callback: @escaping (_ data: Data?) -> Void) {
        lastSearchQuery = query
        
        let requestUrl = Request.buildSearchRequestURL(searchQuery: query) // TODO: add guard
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
        let requestUrl = Request.buildSearchRequestURL(searchQuery: searchQuery, additionalParams: nextRequestParams)
        
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
        let requestUrl = Request.buildSearchRequestURL(searchQuery: searchQuery, additionalParams: previousRequestParams)
        
        requestStickerByURL(requestUrl, callback: callback);
    }
    
    fileprivate func requestStickerByURL(_ url: URL, callback: @escaping (_ data: Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard (error == nil) else {
                print(error!)
                return
            }
            callback(data)
        }.resume()
    }
    
    // MARK: - Bot API
    
    
    // MARK: - Building URL
    static fileprivate func buildSearchRequestURL(searchQuery: String, additionalParams: [String: String]? = nil) -> URL {
        var resourceRequestParams = [
            RequestConstants.RequestKeys.SecretKey: RequestConstants.RequestValues.SecretKey,
            RequestConstants.RequestKeys.ObjectWidth: RequestConstants.RequestValues.ObjectWidth,
            RequestConstants.RequestKeys.SearchQuery: searchQuery
        ]
        
        if let additionalParams = additionalParams {
            for (key, value) in additionalParams {
                resourceRequestParams[key] = value
            }
        }
        
        let requestUrl = stickeroidUrlFromParameters(requestType: .SearchAPI, parameters: resourceRequestParams)
        return requestUrl
    }
    
    static fileprivate func buildBotRequestURL(searchQuery: String) -> URL {
        var resourceRequestParams = [
            RequestConstants.RequestKeys.NumberOfObjects: RequestConstants.RequestValues.NumberOfObjects,
            RequestConstants.RequestKeys.SecretKey: RequestConstants.RequestValues.SecretKey,
            RequestConstants.RequestKeys.ObjectWidth: RequestConstants.RequestValues.ObjectWidth,
            RequestConstants.RequestKeys.SearchQuery: searchQuery
        ]
        
        let requestUrl = stickeroidUrlFromParameters(requestType: .BotAPI, parameters: resourceRequestParams)
        return requestUrl
    }
    
    static fileprivate func stickeroidUrlFromParameters(requestType: RequestType, parameters: [String:String]) -> URL {
        var components = URLComponents()
        
        components.scheme = RequestConstants.APIScheme
        components.host = RequestConstants.APIHost
        
        switch(requestType) {
        case .SearchAPI:
            components.path = RequestConstants.SearchAPIPath
            break
        case .BotAPI:
            components.path = RequestConstants.BotAPIPath
        }
        
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
