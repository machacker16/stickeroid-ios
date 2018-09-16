//
//  MessagesViewController+UICollectionViewDelegate.swift
//  Stickeroid MessagesExtension
//
//  Created by Vadym Sidorov on 9/16/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

extension MessagesViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = (collectionView.cellForItem(at: indexPath) as! StickerCell)
        
        guard let fullImageURL = cell.fullImageURL else {
            return
        }
        
        // Border fading animation
        let highlightAnimation = createStickerHighlightAnimation()
        cell.layer.add(highlightAnimation, forKey: nil)
        
        // Copy to pasteboard
        URLSession.shared.dataTask(with: fullImageURL) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            UIPasteboard.general.image = UIImage(data: data!)
            }.resume()
    }
    
    fileprivate func createStickerHighlightAnimation() -> CABasicAnimation {
        let backgroundColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        backgroundColorAnimation.fromValue = UIConstants.StickeroidOrange.withAlphaComponent(0.75).cgColor
        backgroundColorAnimation.toValue = UIConstants.CellBackgroundColor
        backgroundColorAnimation.duration = UIConstants.StickerHighlightAnimationDuration
        backgroundColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        backgroundColorAnimation.isRemovedOnCompletion = false
        backgroundColorAnimation.fillMode = kCAFillModeForwards
        
        return backgroundColorAnimation
    }
}
