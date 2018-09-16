//
//  MessagesViewController+UICollectionViewDataSource.swift
//  Stickeroid MessagesExtension
//
//  Created by Vadym Sidorov on 9/16/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit
import SDWebImage

extension MessagesViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RequestConstants.ItemsPerRequest
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.CellReusabilityIdentifier, for: indexPath) as! StickerCell
        
        guard let stickerURLs = lastQueryStickerUrls else {
            cell.imageView.image = #imageLiteral(resourceName: "stickeroid_logo.png")
            return cell
        }
        
        cell.layer.borderWidth = 1.5
        cell.layer.cornerRadius = 3.0
        cell.layer.borderColor = UIColor.gray.withAlphaComponent(0.65).cgColor
        cell.layer.backgroundColor = UIConstants.CellBackgroundColor
        
        if (indexPath.row < stickerURLs.count) {
            let thumbnailURL = stickerURLs[indexPath.row].0
            let fullImageURL = stickerURLs[indexPath.row].1
            
            cell.thumbnailURL = thumbnailURL
            cell.fullImageURL = fullImageURL
            
            // Library guarantees same URL won't be fetched twice
            cell.imageView.sd_setImage(with: cell.thumbnailURL)
        }
        
        return cell
    }
}
