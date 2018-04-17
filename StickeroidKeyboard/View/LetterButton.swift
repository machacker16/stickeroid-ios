//
//  LetterButton.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/14/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

class LetterButton: STButton {
    
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
}

