//
//  Constants.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/24/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

struct UIConstants {

    static let StandardVerticalMargin: CGFloat = 8.0
    static let KeyboardHeightCollectionVisible: CGFloat = 336.0
    static let KeyboardHeightCollectionViewHidden: CGFloat = UIConstants.KeyboardHeightCollectionVisible - UIConstants.CollectionViewHeight - UIConstants.StandardVerticalMargin
    
    static let CollectionViewRows = 1
    static let CollectionViewHeight: CGFloat = 70.0
    
    // Colors
    static let StickeroidOrange = UIColor(red: 254.0/255.0, green: 220.0/255.0, blue: 67.0/255.0, alpha: 1.0)
    static let CellBackgroundColor = UIColor.gray.withAlphaComponent(0.2).cgColor
    
    // Animations
    static let StickersRolloutDuration = 0.25
    static let StickerHighlightAnimationDuration = 0.75
    
    // Tags
    static let LetterButtonTag = 1
    static let CellReusabilityIdentifier = "StickeroidCell"
}
