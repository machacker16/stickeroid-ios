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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200.0, height: 200.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = (collectionView.cellForItem(at: indexPath) as! StickerCell)
        
        guard let fullImageURL = cell.fullImageURL else {
            return
        }
        
        // Border fading animation
        let highlightAnimation = createStickerHighlightAnimation()
        cell.layer.add(highlightAnimation, forKey: nil)
        
        self.requestPresentationStyle(.compact)
        
        // Compose a message
        URLSession.shared.dataTask(with: fullImageURL) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            let layout = MSMessageTemplateLayout()
            layout.image = UIImage(data: data!)
            
            let message = MSMessage(session: MSSession())
            message.layout = layout
            
            guard let conversation = self.activeConversation else { fatalError("Expected a conversation") }
            
            conversation.insert(message) { error in
                if let error = error {
                    print(error)
                }
            }
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
