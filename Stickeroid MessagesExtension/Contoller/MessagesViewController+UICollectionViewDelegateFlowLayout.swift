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
        
        let paddingSpace = UIConstants.CollectionViewSectionInsets.left * (UIConstants.CollectionViewColumns + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / UIConstants.CollectionViewColumns - 2.0
        
        return CGSize(width: widthPerItem, height: widthPerItem)
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
