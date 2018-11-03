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
        
        // Scaling animation
        let transformAnimation = createStickerHighlightAnimation()
        cell.stickerImageView.layer.add(transformAnimation, forKey: nil)
        
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
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = CATransform3DIdentity
        transformAnimation.toValue = CATransform3DScale(CATransform3DIdentity, 0.85, 0.85, 1.0)
        transformAnimation.duration = UIConstants.StickerHighlightAnimationDuration / 2.0
        transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transformAnimation.fillMode = CAMediaTimingFillMode.forwards
        transformAnimation.autoreverses = true
        
        return transformAnimation
    }
}
