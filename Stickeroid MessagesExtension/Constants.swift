//
//  Constants.swift
//  Stickeroid MessagesExtension
//
//  Created by Vadym Sidorov on 9/16/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

struct Constants {
    static let DefaultRequestQuery = "hello";
}

struct UIConstants {
    // Margins
    static let StandardVerticalMargin: CGFloat = 8.0
    
    // Colors
    static let StickeroidOrange = UIColor(red: 254.0/255.0, green: 143.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let CellNormalBackgroundColor = UIColor.gray.withAlphaComponent(0.0).cgColor
    static let CellPressedBackgroundColor = UIColor.gray.withAlphaComponent(0.25).cgColor
    static let StickeroidGray = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0).cgColor
    
    // Animations
    static let StickerHighlightAnimationDuration = 1.0
    
    // Misc
    static let CollectionViewSectionsCount = 1
    static let CollectionViewColumns: CGFloat = 4
    static let CollectionViewSectionInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 32.0, right: 8.0)
    static let CellReusabilityIdentifier = "StickeroidCell"
}
