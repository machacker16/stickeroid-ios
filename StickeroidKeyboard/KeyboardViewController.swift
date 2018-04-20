//
//  KeyboardViewController.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/6/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit
import SDWebImage

class KeyboardViewController: UIInputViewController, UICollectionViewDataSource/*, UICollectionViewDelegateFlowLayout*/ {
    
    var keyboardView: UIView!
    var heightConstraint: NSLayoutConstraint?
    var lastQueryStickerUrls: [StickerURL]?
    
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    @IBOutlet weak var queryField: UITextField!
    
    // key is lowercase letter
    var letterButtonsMap = [String: LetterButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKeyboardView()
        
        self.heightConstraint = NSLayoutConstraint(item: self.inputView!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 200.0)
        
        stickerCollectionView.register(StickerCell.self, forCellWithReuseIdentifier: Constants.CellReusabilityIdentifier)
        stickerCollectionView.register(UINib(nibName: "StickerCell", bundle: .main), forCellWithReuseIdentifier: Constants.CellReusabilityIdentifier)
        stickerCollectionView.dataSource = self
//        stickerCollectionView.delegate = self
        
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
                if button.tag == Constants.LetterButtonTag {
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
        self.heightConstraint!.constant = Constants.KeyboardHeight
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
    
    @IBAction func deletePressed(_ sender: KeyboardButton) {
        self.textDocumentProxy.deleteBackward()
    }
    
    @IBAction func returnPressed(_ sender: KeyboardButton) {
        //TODO: create computed property for query, which automatically parses non-valid queries and returns nil
        guard let query = queryField.text else {
            return
        }
        
        Request.getStickerURLsFor(searchQuery: query, numberOfStickers: RequestConstants.ItemsPerRequest) { (_ urls: [StickerURL]) in            
            self.lastQueryStickerUrls = urls
            self.stickerCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSourceController
extension KeyboardViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RequestConstants.ItemsPerRequest
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReusabilityIdentifier, for: indexPath) as! StickerCell
        
        guard let stickerURLs = lastQueryStickerUrls else {
            cell.imageView.image = #imageLiteral(resourceName: "stickeroid_logo.png")
            return cell
        }

        //TODO: safe
        let thumbnailURL = stickerURLs[indexPath.row].0 // SECTION COULD BE WRONG PROPERTY IN THIS CASE
        
        // Works bad on each scrolling performed. Need better solution.
        cell.imageView.sd_setImage(with: thumbnailURL)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
//extension KeyboardViewController {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//
//        return CGSize(width: 20, height: 20)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
//}








