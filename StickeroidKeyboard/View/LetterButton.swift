//
//  LetterButton.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/14/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

enum LetterButtonState {
    case LowerCase
    case UpperCase
}

class LetterButton: KeyboardButton {
    
    static var letterButtonsState: LetterButtonState = .LowerCase
    var buttonStates = [LetterButtonState: String]()
    
    var providedText: String {
        get {
            return buttonStates[LetterButton.letterButtonsState]!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLetterButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLetterButton()
    }
    
    func initLetterButton() {
        self.tag = UIConstants.LetterButtonTag
        buttonStates[.LowerCase] = self.currentTitle!
        buttonStates[.UpperCase] = self.currentTitle!.uppercased()
    }
}

