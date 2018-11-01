//
//  MessagesViewController+UICollectionViewDelegateFlowLayout.swift
//  Stickeroid MessagesExtension
//
//  Created by Vadym Sidorov on 10/12/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

extension MessagesViewController {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = UIConstants.CollectionViewSectionInsets.left * (UIConstants.CollectionViewDesiredColumns + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let possibleItemWidth = availableWidth / UIConstants.CollectionViewDesiredColumns - 3.0
        
        // clamping
        let actualItemWidth = min(max(possibleItemWidth, UIConstants.CellMinSize), UIConstants.CellMaxSize)
        return CGSize(width: actualItemWidth, height: actualItemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIConstants.CollectionViewSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIConstants.CollectionViewSectionInsets.left
    }
}
