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
        
        let requestUrl = STRequest.buildResourceRequestUrl(searchQuery: query)! // TODO: add guard
        getResourceByUrl(requestUrl, callback: callback);
    }
    
    func getNextResourceFromLastSession(callback: @escaping (_ data: Data?) -> Void) {
        guard let searchQuery = lastSearchQuery else {
            print("Can't get next resource: no search was performed before.")
            return
        }
        
        let requestUrl = STRequest.buildResourceRequestUrl(searchQuery: searchQuery, isNextResourceRequest: true)!
        
        getResourceByUrl(requestUrl, callback: callback);
    }

    func getResourceByUrl(_ url: URL, callback: @escaping (_ data: Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                callback(data)
            } else {
                print(error!)
            }
            }.resume()
    }
    
    static func buildResourceRequestUrl(searchQuery: String, isNextResourceRequest: Bool = false) -> URL? {
        var resourceRequestParams = [
            STConstants.RequestKeys.SecretKey: STConstants.RequestValues.SecretKey,
            STConstants.RequestKeys.SearchQuery: searchQuery
        ]
        
        if isNextResourceRequest {
            resourceRequestParams[STConstants.RequestKeys.NextQuery] = STConstants.RequestValues.NextQuery
        }
        
        let requestParamsString = buildRequestParamsString(parameters: resourceRequestParams as [String:AnyObject])
        let requestString = STConstants.ApiBaseUrl + requestParamsString
        
        return URL(string: requestString)
    }
    
    
    static func buildRequestParamsString(parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        }
        
        var concatenatedKeyValues = [String]()
        
        for (key, value) in parameters {
            let strVal = "\(value)"
            let escapedVal = strVal.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            concatenatedKeyValues.append(key + "=" + escapedVal!) // WARNING: may be needed to add string interpolation to escapedVal!
        }
        
        return "?\(concatenatedKeyValues.joined(separator: "&"))"
    }
    
}
