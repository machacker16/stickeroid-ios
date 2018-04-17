//
//  STConstants.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 8/2/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import Foundation

struct RequestConstants {
    
    static let ItemsPerRequest = 12
    static let APIScheme = "https"
    static let APIHost = "stickeroid.com"
    static let APIPath = "/api"
    
    struct RequestKeys {
        static let SecretKey = "k"
        static let SearchQuery = "s"
        static let ObjectId = "i"
        static let ObjectWidth = "w"
        static let ObjectHeight = "h"
        static let NextQuery = "next"
        static let PreviousQuery = "prev"
    }
    
    struct RequestValues {
        static let SecretKey = "d147203e"
        static let ObjectWidth = "256"
        static let NextQuery = ""
        static let PreviousQuery = ""
    }
    
}
