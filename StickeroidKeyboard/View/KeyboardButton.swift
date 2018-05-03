//
//  StickeroidButton.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/14/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {
    
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
    
    @IBInspectable var margin: CGFloat = 5.0
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
}
