//
//  KeyboardViewController.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/6/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    var keyboardView: UIView!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadKeyboardView();
    }
    
    func loadKeyboardView() {
        let keyboardViewNib = UINib(nibName: "KeyboardView", bundle: nil)
        keyboardView = keyboardViewNib.instantiate(withOwner: self, options: nil)[0] as! UIView
        keyboardView.frame = self.view.bounds
        keyboardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(keyboardView)
        view.backgroundColor = keyboardView.backgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
//        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
