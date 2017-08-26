//
//  ViewController.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 7/29/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var resourceView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let requestInstance = STRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stickeroidLogoImage = #imageLiteral(resourceName: "logo_text.png")
        addNavigationBarImage(stickeroidLogoImage)
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
        requestInstance.getNextResourceFromLastSession {data in
            performUIUpdatesOnMain {
                self.resourceView.image = UIImage(data: data!)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
        //scrollView.contentInset = UIEdgeInsetsMake(0, 0, 250, 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        //scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}

