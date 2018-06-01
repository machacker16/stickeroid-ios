//
//  SpaceButton.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 5/8/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

class SpaceButton: LetterButton {
    override func initLetterButton() {
        self.tag = UIConstants.LetterButtonTag
        buttonStates[.LowerCase] = " "
        buttonStates[.UpperCase] = " "
    }
}
