//
//  KeyboardViewController.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/6/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit
import SDWebImage

class KeyboardViewController: UIInputViewController {
    
    var keyboardView: UIView!
    var heightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var stickerView: UIImageView!
    @IBOutlet weak var queryField: UITextField!
    
    // key is lowercase letter
    var letterButtonsMap = [String: LetterButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.heightConstraint = NSLayoutConstraint(item: self.inputView!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 200.0)

        loadKeyboardView();
        setupLetterButtons()
    }
    
    func loadKeyboardView() {
        let keyboardViewNib = UINib(nibName: "KeyboardView", bundle: nil)
        keyboardView = keyboardViewNib.instantiate(withOwner: self, options: nil)[0] as! UIView
        keyboardView.frame = self.view.bounds
        keyboardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        inputView!.addSubview(keyboardView)
        inputView!.backgroundColor = keyboardView.backgroundColor
    }
    
    func setupLetterButtons() {
        for row in self.keyboardView.subviews {
            for button in row.subviews {
                if button.tag == Constants.letterButtonTag {
                    let letterButton = button as! LetterButton
                    self.letterButtonsMap[letterButton.providedText!] = letterButton
                }
            }
        }
        
        for (_, button) in self.letterButtonsMap {
            button.addTarget(self, action: #selector(self.letterButtonPressed(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: Lifecycle callbacks
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if (self.view.frame.size.width == 0 || self.view.frame.size.height == 0) {
            return
        }
        
        if let heightConstraint = self.heightConstraint {
            self.inputView?.removeConstraint(heightConstraint)
        }
        self.heightConstraint!.constant = Constants.keyboardHeight
        self.inputView?.addConstraint(self.heightConstraint!)
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
        
//        var textColor: UIColor
//        let proxy = self.textDocumentProxy
//        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
//            textColor = UIColor.white
//        } else {
//            textColor = UIColor.black
//        }
//        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

    // MARK: Button actions
    @objc func letterButtonPressed(_ sender: LetterButton) {
        self.textDocumentProxy.insertText(sender.providedText!)
    }
    
    @IBAction func deletePressed(_ sender: STButton) {
        self.textDocumentProxy.deleteBackward()
    }
    
    @IBAction func returnPressed(_ sender: STButton) {
        let requestInstance = STRequest()
        
        guard let query = queryField.text else {
            return
        }
        
        stickerView.sd_setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"), placeholderImage: nil)

        
        requestInstance.getResourceWithSearchQuery(query) { (data) in
            performUIUpdatesOnMain {
                self.stickerView.image = UIImage(data: data!)
            }
        }
    }
    
//    @IBAction func requestNextResource(_ sender: UIButton) {
//        requestInstance.requestNextStickerFromLastSession {data in
//            performUIUpdatesOnMain {
//                self.resourceView.image = UIImage(data: data!)
//            }
//        }
//    }
//    
//    @IBAction func requestPreviousResource(_ sender: UIButton) {
//        requestInstance.requestPreviousStickerFromLastSession { data in
//            performUIUpdatesOnMain {
//                self.resourceView.image = UIImage(data: data!)
//            }
//        }
//    }
//    
//    @IBAction func performResourceSearch(_ sender: UITextField) {
//        
//        guard let searchQuery = sender.text else {
//            print("Search query is nil.")
//            return
//        }
//        
//        requestInstance.getResourceWithSearchQuery(searchQuery) { (data) in
//            performUIUpdatesOnMain {
//                self.resourceView.image = UIImage(data: data!)
//            }
//        }
//    }
    
}
