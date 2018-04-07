//
//  ViewController.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 7/29/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stickeroidLogoImage = #imageLiteral(resourceName: "logo_text_white.png")
        addNavigationBarImage(stickeroidLogoImage)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
//    @IBAction func hideSearchFieldPlaceholder(_ sender: SearchField) {
//        sender.placeholder = nil
//    }
//
//    @IBAction func showSearchFieldPlaceholder(_ sender: SearchField) {
//        if (sender.text == "" || sender.text == nil) {
//            sender.placeholder = SEARCH_FIELD_PLACEHOLDER
//        }
//    }
    
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
}

