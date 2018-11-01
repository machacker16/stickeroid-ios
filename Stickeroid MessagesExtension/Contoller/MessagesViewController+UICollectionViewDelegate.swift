//
//  MessagesViewController+UICollectionViewDelegate.swift
//  Stickeroid MessagesExtension
//
//  Created by Vadym Sidorov on 9/16/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit
import Messages

extension MessagesViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = (collectionView.cellForItem(at: indexPath) as! StickerCell)
        
        guard cell.isLoaded else {
            // TODO: try reloading
            return
        }
        
        guard let stickerImage = cell.stickerImageView.image else {
            return
        }
        
        // Border fading animation
        let highlightAnimation = createStickerHighlightAnimation()
        cell.layer.add(highlightAnimation, forKey: nil)
        
        // Shrink extension
        self.requestPresentationStyle(.compact)
        
        // Compose a message
        let layout = MSMessageTemplateLayout()
        layout.image = stickerImage
        
        let message = MSMessage(session: MSSession())
        message.layout = layout
        
        guard let conversation = self.activeConversation else { fatalError("Expected a conversation") }
        
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    fileprivate func createStickerHighlightAnimation() -> CABasicAnimation {
        let backgroundColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        backgroundColorAnimation.fromValue = UIConstants.CellPressedBackgroundColor
        backgroundColorAnimation.toValue = UIConstants.CellNormalBackgroundColor
        backgroundColorAnimation.duration = UIConstants.StickerHighlightAnimationDuration
        backgroundColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        backgroundColorAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        return backgroundColorAnimation
    }
}
