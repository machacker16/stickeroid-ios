//
//  ViewController.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 7/29/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let SEARCH_FIELD_PLACEHOLDER = "Translate To Sticker"
    
    @IBOutlet weak var resourceView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let requestInstance = STRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stickeroidLogoImage = #imageLiteral(resourceName: "logo_text_white.png")
        addNavigationBarImage(stickeroidLogoImage)
        
        searchTextField.placeholder = SEARCH_FIELD_PLACEHOLDER
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func hideSearchFieldPlaceholder(_ sender: SearchField) {
        sender.placeholder = nil
    }
    
    @IBAction func showSearchFieldPlaceholder(_ sender: SearchField) {
        if (sender.text == "" || sender.text == nil) {
            sender.placeholder = SEARCH_FIELD_PLACEHOLDER
        }
    }
    
    func addNavigationBarImage(_ image: UIImage) {
        let IMAGE_SIZE_COEFF = CGFloat(0.88)
        
        let imageView = UIImageView(image: image)
        let navController = navigationController!
        
        let frameWidth = navController.navigationBar.frame.size.width * IMAGE_SIZE_COEFF
        let frameHeight = navController.navigationBar.frame.size.height * IMAGE_SIZE_COEFF
        let frameSize = CGSize(width: frameWidth, height: frameHeight)

        let frameOriginX = frameSize.width / 2 - image.size.width / 2
        let frameOriginY = frameSize.height / 2 - image.size.height / 2
        let frameOriginXY = CGPoint(x: frameOriginX, y: frameOriginY)
        
        imageView.frame = CGRect(origin: frameOriginXY, size: frameSize)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    @IBAction func performResourceSearch(_ sender: UITextField) {
        
        guard let searchQuery = sender.text else {
            print("Search query is nil.")
            return
        }
        
        requestInstance.getResourceWithSearchQuery(searchQuery) { (data) in
            performUIUpdatesOnMain {
                self.resourceView.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func requestNextResource(_ sender: UIButton) {
        requestInstance.requestNextStickerFromLastSession {data in
            performUIUpdatesOnMain {
                self.resourceView.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func requestPreviousResource(_ sender: UIButton) {
        requestInstance.requestPreviousStickerFromLastSession { data in
            performUIUpdatesOnMain {
                self.resourceView.image = UIImage(data: data!)
            }
        }
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        var keyboardHeight: CGFloat
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            
            scrollView.setContentOffset(CGPoint(x: 0, y: keyboardHeight), animated: true)
        }
    }
    
    func keyboardWillDisappear() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

