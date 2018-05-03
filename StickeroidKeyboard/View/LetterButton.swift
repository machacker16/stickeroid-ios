//
//  LetterButton.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/14/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

class LetterButton: KeyboardButton {
    
    var providedText: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLetterButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLetterButton()
    }
    
    func initLetterButton() {
        self.tag = Constants.LetterButtonTag
        self.providedText = self.currentTitle
    }
    
    @IBInspectable var margin: CGFloat = 5.0
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
}

