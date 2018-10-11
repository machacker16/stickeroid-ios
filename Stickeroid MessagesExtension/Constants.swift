//
//  Constants.swift
//  Stickeroid MessagesExtension
//
//  Created by Vadym Sidorov on 9/16/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

struct UIConstants {
    
    static let StandardVerticalMargin: CGFloat = 8.0
    
//    static let CollectionViewRows = 1
    
    // Colors
    static let StickeroidOrange = UIColor(red: 254.0/255.0, green: 220.0/255.0, blue: 67.0/255.0, alpha: 1.0)
    static let CellNormalBackgroundColor = UIColor.gray.withAlphaComponent(0.0).cgColor
    static let CellPressedBackgroundColor = UIColor.gray.withAlphaComponent(0.25).cgColor
    
    // Animations
    static let StickerHighlightAnimationDuration = 1.0
    
    // Tags
    static let CellReusabilityIdentifier = "StickeroidCell"
}
