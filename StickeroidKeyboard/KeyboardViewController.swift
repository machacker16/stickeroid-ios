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

    weak var keyboardView: UIView!
    var heightConstraint: NSLayoutConstraint?
    var lastQueryStickerUrls: [StickerURL]?
    var isFirstSearch = false
    
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    @IBOutlet weak var queryField: UITextField!
    
    // key is lowercase letter
    var letterButtonsMap = [String: LetterButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstSearch = true
        
        loadKeyboardView()
        setupConstraints()
        setupCollectionView()
        setupLetterButtons()
    }
    
    func loadKeyboardView() {
        let keyboardViewNib = UINib(nibName: "KeyboardView", bundle: nil)
        guard let keyboardView = keyboardViewNib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            print("Coudn't instantiate keyboard view from nib")
            return
        }
        
        keyboardView.frame = self.view.bounds
        keyboardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.keyboardView = keyboardView
        inputView!.addSubview(keyboardView)
        inputView!.backgroundColor = keyboardView.backgroundColor
    }
    
    func setupConstraints() {
        guard let inputView = self.inputView else {
            print("No inputView in viewDidLoad")
            return
        }
        
        let keyboardHeight = isFirstSearch ? UIConstants.KeyboardHeightCollectionViewHidden : UIConstants.KeyboardHeightCollectionVisible
        heightConstraint = NSLayoutConstraint(item: inputView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: keyboardHeight)
        inputView.addConstraint(heightConstraint!)
    }
    
    func setupCollectionView() {
        stickerCollectionView.register(StickerCell.self, forCellWithReuseIdentifier: UIConstants.CellReusabilityIdentifier)
        stickerCollectionView.register(UINib(nibName: "StickerCell", bundle: .main), forCellWithReuseIdentifier: UIConstants.CellReusabilityIdentifier)
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
    }
    
    func setupLetterButtons() {
        for row in self.keyboardView.subviews {
            for button in row.subviews {
                if button.tag == UIConstants.LetterButtonTag {
                    let letterButton = button as! LetterButton
                    self.letterButtonsMap[letterButton.providedText] = letterButton
                }
            }
        }
        
        for (_, button) in self.letterButtonsMap {
            button.addTarget(self, action: #selector(self.letterButtonPressed(_:)), for: .touchUpInside)
        }
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
        
        if isFirstSearch {
            isFirstSearch = false
            heightConstraint?.constant = UIConstants.KeyboardHeightCollectionVisible
        }   
    }
}

// MARK: - UICollectionViewDataSourceController
extension KeyboardViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RequestConstants.ItemsPerRequest
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.CellReusabilityIdentifier, for: indexPath) as! StickerCell
        
        guard let stickerURLs = lastQueryStickerUrls else {
            cell.imageView.image = #imageLiteral(resourceName: "stickeroid_logo.png")
            return cell
        }
        
        cell.layer.borderWidth = 1.5
        cell.layer.cornerRadius = 3.0
        cell.layer.borderColor = UIColor.gray.withAlphaComponent(0.65).cgColor
        cell.layer.backgroundColor = UIConstants.CellBackgroundColor
        
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
        
        // Border fading animation
        let highlightAnimation = createStickerHighlightAnimation()
        cell.layer.add(highlightAnimation, forKey: nil)
        
        // Copy to pasteboard
        URLSession.shared.dataTask(with: fullImageURL) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            UIPasteboard.general.image = UIImage(data: data!)
        }.resume()
    }
    
    fileprivate func createStickerHighlightAnimation() -> CABasicAnimation {
        let backgroundColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        backgroundColorAnimation.fromValue = UIConstants.StickeroidOrange.withAlphaComponent(0.75).cgColor
        backgroundColorAnimation.toValue = UIConstants.CellBackgroundColor
        backgroundColorAnimation.duration = UIConstants.StickerHighlightAnimationDuration
        backgroundColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        backgroundColorAnimation.isRemovedOnCompletion = false
        backgroundColorAnimation.fillMode = kCAFillModeForwards

        return backgroundColorAnimation
    }
}
