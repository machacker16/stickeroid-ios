//
//  StickeroidButton.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/14/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {
    
    @IBInspectable var extendTouchAreaBy: CGFloat = 5.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAppearance()
    }
    
    func setupAppearance() {
        self.layer.cornerRadius = 5
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = self.bounds.insetBy(dx: -extendTouchAreaBy, dy: -extendTouchAreaBy)
        return area.contains(point)
    }
}
