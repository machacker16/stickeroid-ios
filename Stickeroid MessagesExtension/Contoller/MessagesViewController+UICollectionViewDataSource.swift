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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return UIConstants.CollectionViewSectionsCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let stickerUrls = self.lastQueryStickerUrls else {
            return RequestConstants.ItemsPerRequest
        }
        
        return stickerUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.CellReusabilityIdentifier, for: indexPath) as! StickerCell
        
        cell.isLoaded = false
        cell.fullImageURL = nil
        
        guard let stickerURLs = lastQueryStickerUrls else {
            cell.stickerImageView.image = #imageLiteral(resourceName: "placeholder_300px.png")
            return cell
        }
        
        if (indexPath.row < stickerURLs.count) {
            let fullImageURL = stickerURLs[indexPath.row].image
            cell.fullImageURL = fullImageURL
            
            // Library guarantees same URL won't be fetched twice
            cell.stickerImageView.sd_setImage(
                with: cell.fullImageURL,
                placeholderImage: #imageLiteral(resourceName: "placeholder_300px.png"),
                options: SDWebImageOptions(rawValue: 0),
                completed: { [cell] image, error, cacheType, imageURL in
                    guard error == nil else {
                        return
                    }
                    cell.stickerImageView.layer.opacity = 1.0
                    
                    let animation = self.createStickerAppearanceAnimation()
                    cell.stickerImageView.layer.add(animation, forKey: nil)
                    
                    cell.isLoaded = true
                }
            )
        }
        
        return cell
    }
    
    func createStickerAppearanceAnimation() -> CABasicAnimation {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.35
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = 0.34
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        return opacityAnimation
    }
}
