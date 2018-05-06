//
//  StickeroidButton.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/14/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {
    
    @IBInspectable var extendTouchAreaBy = CGSize(width: 3.0, height: 5.0)
    
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
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = self.bounds.insetBy(dx: -extendTouchAreaBy.width, dy: -extendTouchAreaBy.height)
        return area.contains(point)
    }
}
