//
//  KeyboardViewController.swift
//  StickeroidKeyboard
//
//  Created by Vadym Sidorov on 3/6/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit
import SDWebImage

class KeyboardViewController: UIInputViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var keyboardView: UIView!
    var heightConstraint: NSLayoutConstraint?
    var lastQueryStickerUrls: [StickerURL]?
    
    @IBOutlet weak var stickerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    @IBOutlet weak var queryField: UITextField!
    
    // key is lowercase letter
    var letterButtonsMap = [String: LetterButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKeyboardView()
        setupKeyboardAppearance()
        
        self.heightConstraint = NSLayoutConstraint(item: self.inputView!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: Constants.KeyboardHeight)
        
        stickerCollectionView.register(StickerCell.self, forCellWithReuseIdentifier: Constants.CellReusabilityIdentifier)
        stickerCollectionView.register(UINib(nibName: "StickerCell", bundle: .main), forCellWithReuseIdentifier: Constants.CellReusabilityIdentifier)
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
        
        setupLetterButtons()
    }
    
    func loadKeyboardView() {
        let keyboardViewNib = UINib(nibName: "KeyboardView", bundle: nil)
        keyboardView = keyboardViewNib.instantiate(withOwner: self, options: nil)[0] as! UIView
        keyboardView.frame = self.view.bounds
        keyboardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        inputView!.addSubview(keyboardView)
    }
    
    func setupKeyboardAppearance() {
        inputView!.backgroundColor = keyboardView.backgroundColor
    }
    
    func setupLetterButtons() {
        for row in self.keyboardView.subviews {
            for button in row.subviews {
                if button.tag == Constants.LetterButtonTag {
                    let letterButton = button as! LetterButton
                    self.letterButtonsMap[letterButton.providedText] = letterButton
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
        self.textDocumentProxy.insertText(sender.providedText)
    }
    
    @IBAction func keyboardSelectionPressed(_ sender: KeyboardButton) {
        self.advanceToNextInputMode()
    }
    
    @IBAction func capslockPressed(_ sender: KeyboardButton) {
        switch LetterButton.letterButtonsState {
        case .LowerCase:
            LetterButton.letterButtonsState = .UpperCase
            break
        case .UpperCase:
            LetterButton.letterButtonsState = .LowerCase
            break
        }
    }
    
    @IBAction func deletePressed(_ sender: KeyboardButton) {
        self.textDocumentProxy.deleteBackward()
    }
    
    @IBAction func returnPressed(_ sender: KeyboardButton) {
        //TODO: create computed property for query, which automatically parses non-valid queries and returns nil
        guard let query = queryField.text else {
            return
        }
        
        Request.getStickerURLsFor(searchQuery: query,
                                  numberOfStickers: RequestConstants.ItemsPerRequest) { [weak self] (_ urls: [StickerURL]) in
                self?.lastQueryStickerUrls = urls
            
                DispatchQueue.main.async { [weak self] in
                    self?.stickerCollectionView.reloadData()
                }
            }
        
        stickerCollectionView.layoutIfNeeded()
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.stickerViewHeightConstraint.constant = 0
//            self?.stickerCollectionView.layoutIfNeeded()
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

        if (indexPath.row < stickerURLs.count) {
            let thumbnailURL = stickerURLs[indexPath.row].0
            let fullImageURL = stickerURLs[indexPath.row].1
            
            cell.thumbnailURL = thumbnailURL
            cell.fullImageURL = fullImageURL
            // Library guarantees same URL won't be fetched twice
            cell.imageView.sd_setImage(with: cell.thumbnailURL)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension KeyboardViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = (collectionView.cellForItem(at: indexPath) as! StickerCell)
        
        guard let fullImageURL = cell.fullImageURL else {
            return
        }
        
        URLSession.shared.dataTask(with: fullImageURL) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            UIPasteboard.general.image = UIImage(data: data!)
        }.resume()
        
    }
}
