//
//  STRequest.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 8/2/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import Foundation

typealias StickerURL = (thumbnail: URL, image: URL)

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
            guard error == nil else {
                print(error!)
                return
            }
            callback(data)
        }.resume()
    }
    
    // MARK: - Bot API
    static func getStickerURLsFor(searchQuery: String, numberOfStickers: Int, callback: @escaping (_ urls: [StickerURL]) -> Void) {
        requestStickersBundle(searchQuery: searchQuery, numberOfStickers: numberOfStickers) { (_ data: Data?) in
            guard let data = data else {
                print("No data was retreived")
                return
            }
            
            let stickersBundle: [AnyObject]!
            do {
                stickersBundle = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [AnyObject]
            } catch {
                print("Could not parse retreived JSON root.")
                return
            }
            
            var stickerURLs = [StickerURL]()
            for stickerData in stickersBundle {
                //TODO: add checks
                let stickerDataSafe = stickerData as! [String: Any]
                var thumbnailURL = stickerDataSafe[RequestConstants.StickerBundleJsonKeys.Thumbnail] as! String
                var imageURL = stickerDataSafe[RequestConstants.StickerBundleJsonKeys.Image] as! String
                thumbnailURL = "\(Request.buildDomain())\(thumbnailURL)"
                imageURL = "\(Request.buildDomain())\(imageURL)"
                stickerURLs.append((URL(string: thumbnailURL)!, URL(string: imageURL)!))
            }
            callback(stickerURLs)
        }
    }
    
    fileprivate static func requestStickersBundle(searchQuery: String, numberOfStickers: Int, callback: @escaping (_ data: Data?) -> Void) {
        let requestUrl = Request.buildBotRequestURL(searchQuery: searchQuery, numberOfStickers: RequestConstants.ItemsPerRequest)
        
        URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            callback(data)
        }.resume()
    }
    
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
    
    static fileprivate func buildBotRequestURL(searchQuery: String, numberOfStickers: Int) -> URL {
        var resourceRequestParams = [
            RequestConstants.RequestKeys.NumberOfObjects: String(numberOfStickers),
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
    
    //TODO: queryItem
    static fileprivate func buildDomain() -> String {
        return "\(RequestConstants.APIScheme)://\(RequestConstants.APIHost)"
    }
}
