//
//  Constants.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/24/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

struct Constants {
    // Height with collectionView shown
    static let KeyboardHeight: CGFloat = 336.0
    
    static let CollectionViewRows = 1
    static let CollectionViewHeight: CGFloat = 70.0
    
    // Colors
    static let StickeroidOrange = UIColor(red: 254.0/255.0, green: 220.0/255.0, blue: 67.0/255.0, alpha: 1.0)
    
    // Animations
    static let StickersRolloutDuration = 0.25
    static let StickerHighlightAnimationDuration = 0.75
    
    // Tags
    static let LetterButtonTag = 1
    static let CellReusabilityIdentifier = "StickeroidCell"
}